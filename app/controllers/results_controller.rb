class ResultsController < ApplicationController

  def pull_results
    PullTestResultsJob.perform_later

    # flash[:success] = "results queued to pull"

    redirect_to root_path
  end

  # def clear_results
  #   JenkinsJob.destroy_all
  #
  #   flash[:error] = "results deleted"
  #
  #   redirect_to root_path
  # end
end
