class Build < ApplicationRecord

  STATUSES = [STATUS_SUCCESS, STATUS_FAILURE]

  belongs_to :project
  has_many :testcase_runs, dependent: :destroy

  validates_uniqueness_of :number, scope: :project_id

  validates_presence_of :number

  validates_inclusion_of :status, in: STATUSES, if: -> { status.present? }

  def update_summary_data
    testcases = self.testcase_runs

    duration = 0
    status = STATUS_SUCCESS
    testcases.each do |testcase|
      duration += testcase.time
      if testcase.failed?
        status = STATUS_FAILURE
      end
    end

    update_attributes!(duration_in_seconds: duration, status: status)
  end
end
