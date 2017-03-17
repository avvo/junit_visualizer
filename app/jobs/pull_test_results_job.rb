class PullTestResultsJob < ActiveJob::Base

  queue_as :default

  def perform(*args)
    # load the defaults
    PROJECT_NAMES.each do |project_name|
      Project.find_or_create_by(name: project_name)
    end

    Project.all.each do |project|
      p "pulling results for #{project.name}"
      project.refresh_project_and_pull_results
    end

  end

end
