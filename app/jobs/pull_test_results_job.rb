class PullTestResultsJob < ActiveJob::Base

  queue_as :default

  def perform(*args)
    # load the defaults
    PROJECT_NAMES.each do |project_name|
      Project.find_or_create_by(name: project_name)
    end

    Project.all.each do |project|
      s3 = S3Wrapper.new

      p "pulling results for #{project.name}"
      project.retrieve_suite_names_and_builds(s3)
    end

  end

end
