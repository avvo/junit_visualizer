class Project < ApplicationRecord

  has_many :suites, dependent: :destroy
  has_many :builds, dependent: :destroy

  def retrieve_results_from_s3
    # s3 = S3Wrapper.new

  end

  def retrieve_suite_names
    # in our jenkins set up, the suite is part of the job name. we need to figure out what sub directories
    s3 = S3Wrapper.new

    suites = s3.suite_name_list(name)
    build_numbers = s3.build_number_list(name)

    puts "suites #{suites}"
    puts "builds #{build_numbers}"

    suites.each do |suite_name|
      Suite.find_or_create_by(project: self, name: suite_name)
    end

    build_numbers.each do |build_number|
      Build.find_or_create_by(project: self, number: build_number)
    end
  end

end
