class PullTestResultsJob < ActiveJob::Base

  queue_as :default

  def perform(*args)
    # load the defaults
    PROJECT_NAMES.each do |project_name|
      Project.find_or_create_by(name: project_name)
    end

    Project.all.each do |job|
      p "pulling results for #{job.name}"
      job.retrieve_suite_names
    end

  end

end
