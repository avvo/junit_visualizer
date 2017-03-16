require 'junit_parser'

class Project < ApplicationRecord

  has_many :suites, dependent: :destroy
  has_many :builds, dependent: :destroy
  has_many :testcases, dependent: :destroy

  def retrieve_suite_names_and_builds(s3Wrapper)
    # in our jenkins set up, the suite is part of the job name. we need to figure out what sub directories
    suites = s3Wrapper.suite_name_list(name)
    build_numbers = s3Wrapper.build_number_list(name)

    puts "suites #{suites}"
    puts "builds #{build_numbers}"

    process_suites(suites)

    process_builds(build_numbers: build_numbers, s3Wrapper: s3Wrapper)
  end

  def process_suites(suites)
    suites.each do |suite_name|
      Suite.find_or_create_by(project: self, name: suite_name)
    end
  end

  def process_builds(build_numbers:, s3Wrapper:)
    count = 0
    build_numbers.each do |build_number|
      build = Build.find_or_initialize_by(project: self, number: build_number)

      if build.new_record?
        count += 1
        return if count > BUILDS_TO_PULL

        build.save!

        filenames = s3Wrapper.file_list_from_project_and_build(project_name: name, build_number: build_number)

        filenames.each do |filename|
          suite = suite_from_filename(filename: filename, s3Wrapper: s3Wrapper)

          temp_filename = s3Wrapper.download_from_s3(filename)

          process_junit_file(temp_filename: temp_filename, build: build, suite: suite)
        end
      end
    end

  end

  def suite_from_filename(filename:, s3Wrapper:)
    suite_name = s3Wrapper.parse_suite_name(name, filename)
    suites = Suite.where(project: self, name: suite_name)
    suites.first
  end

  def process_junit_file(temp_filename:, build:, suite: )
    p "processing build #{build.number} for project: #{name}"
    junit_suite = JUnitParser.parse_junit(temp_filename)

    process_junit_suite(junit_suite: junit_suite, build_id: build.id, suite: suite)
  end

  def process_junit_suite(junit_suite:, build_id:, suite:)
    junit_suite.test_cases.each do |test_case|

      test = Testcase.find_or_create_by(
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
        full_error: test_case.message
      )
    end
  end

end
