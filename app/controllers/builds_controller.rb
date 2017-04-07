class BuildsController < ApplicationController

  def show
    @build = Build.includes(:testcase_runs => [:testcase => [:suite]]).find(params[:id])
  end

end
