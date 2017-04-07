class SuitesController < ApplicationController

  def show
    @suite = Suite.includes(:project, :testcases).find(params[:id])
  end

end
