class Build < ApplicationRecord

  STATUSES = [STATUS_SUCCESS, STATUS_FAILURE]

  belongs_to :project
  has_many :testcase_runs, -> { order(passed: :asc, time: :desc) }, dependent: :destroy

  validates_uniqueness_of :number, scope: :project_id

  validates_presence_of :number

  def update_summary_data
    duration = 0
    status = STATUS_SUCCESS
    testcase_runs.each do |testcase_run|
      duration += testcase_run.time
      if testcase_run.failed?
        status = STATUS_FAILURE
      end
    end

    update_attributes!(duration_in_seconds: duration, status: status)
  end
end
