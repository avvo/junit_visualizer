class PullTestResultsJob < ActiveJob::Base

  queue_as :default

  def perform(*args)
    Project.all.each do |project|
      p "pulling results for #{project.name}"
      project.refresh_project_and_pull_results
    end

  end

end
