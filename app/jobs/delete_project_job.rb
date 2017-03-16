class DeleteProjectJob < ActiveJob::Base

  queue_as :default

  def perform(project_id)
    job = Project.find(project_id)
    job.destroy
  end

end
