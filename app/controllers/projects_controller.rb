class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :duration_data]

  def index
    @projects = Project.all
  end

  def show
    @builds = @project.builds.order(number: :desc)
    raw_suites = @project.suites
    @suites = []
    raw_suites.each do |suite|
      @suites << SuitePresenter.new(suite)
    end
  end

  def chart
  end

  def duration_data
    ret_val = {}
    @builds = @project.builds.where.not(run_date: nil).order(number: :desc).map { |build| ret_val[build.run_date] = build.duration_in_seconds }

    render json: ret_val
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    DeleteProjectJob.perform_later(@project.id)

    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name)
  end

end
