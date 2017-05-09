require 'junit_parser'

class Project < ApplicationRecord
  has_many :suites, dependent: :destroy
  has_many :builds, dependent: :destroy
  has_many :testcases, dependent: :destroy

  validates_presence_of :name

  scope :displayable, -> { where(hide: false) }

  def build_count
    builds.size
  end

  def s3Wrapper
    @s3Wrapper ||= S3Wrapper.new
  end

  def self.create_from_s3_dir
    S3Wrapper.new.project_names.each do |project_name|
      Project.find_or_create_by!(name: project_name)
    end
  end

  def refresh_project_and_pull_results
    process_suites
    process_builds_and_pull_results
  end

  def process_suites
    suites = s3Wrapper.suite_name_list(name)
    puts "suites #{suites}"

    if suites.present?
      suites.each do |suite_name|
        Suite.find_or_create_by!(project: self, name: suite_name)
      end
    else
      Suite.find_or_create_by!(project: self, name: Suite::DEFAULT_NAME)
    end

  end

  def process_builds_and_pull_results
    build_numbers = s3Wrapper.build_number_list(name)

    puts "builds #{build_numbers}"

    count = 0
    build_numbers.each do |build_number|
      if build_exists?(build_number)
        puts "build #{build_number} already exists, skip"
      else
        count += 1
        return if count > BUILDS_TO_PULL
        puts "creating build #{build_number}"
        create_build(build_number)
      end
    end
  end

  def build_exists?(build_number)
    Build.where(project: self, number: build_number).present?
  end

  def create_build(build_number)
    build = Build.new(project: self, number: build_number)

    Build.transaction do
      if build.save!
        filenames = s3Wrapper.file_list_from_project_and_build(project_name: name, build_number: build_number)

        # HACKY: just grab the modified date of the first file.
        run_date = s3Wrapper.file_modified_date(filenames.first)
        build.update_attributes!(run_date: run_date)

        filenames.each do |filename|
          suite = suite_from_filename(filename: filename)

          file_data = s3Wrapper.retrieve_from_s3(filename)

          process_junit_data(data: file_data, build: build, suite: suite)
        end

        build.update_summary_data
      end
    end

  rescue ActiveRecord::RecordNotUnique => e
    # Because the records can take a while to create, we need the index, even though we have the uniqueness validation.
    Rails.logger.info "Found duplicate record, probably because 2 jobs were running at same time. project: #{name}, build_number: #{build_number}"
  end

  def suite_from_filename(filename:)
    suite_name = s3Wrapper.parse_suite_name(name, filename)
    Suite.find_by(project: self, name: suite_name || Suite::DEFAULT_NAME)
  end

  def process_junit_data(data:, build:, suite: )
    p "processing a file for build #{build.number} for project: #{name}"
    junit_suite = JUnitParser.parse_junit(data)

    if junit_suite.present?
      process_junit_suite(junit_suite: junit_suite, build_id: build.id, suite: suite)
    end
  end

  def process_junit_suite(junit_suite:, build_id:, suite:)
    junit_suite.test_cases.each do |test_case|

      test = Testcase.find_or_create_by!(
        name: test_case.name,
        file_name: test_case.file,
        project: self,
        suite: suite,
      )

      TestcaseRun.create!(
        testcase: test,
        build_id: build_id,
        time: test_case.time,
        passed: test_case.passed?,
        skipped: test_case.skipped?,
        full_error: (test_case.message || '').truncate(65000)
      )
    end
  end

end
