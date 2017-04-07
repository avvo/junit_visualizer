class TestcasesController < ApplicationController

  def show
    @testcase = Testcase.includes(:testcase_runs, :suite).find(params[:id])
  end

end
