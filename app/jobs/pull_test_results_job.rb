class PullTestResultsJob < ActiveJob::Base

  queue_as :default

  def perform(*args)
    Project.create_from_s3_dir

    Project.all.each do |project|
      p "pulling results for #{project.name}"
      project.refresh_project_and_pull_results
    end

  end

end
