class Build < ApplicationRecord
  belongs_to :project
  has_many :testcase_runs, dependent: :destroy

  def update_summary_data
    testcases = self.testcase_runs

    duration = 0
    status = STATUS_SUCCESS
    testcases.each do |testcase|
      duration += testcase.time
      if !testcase.passed
        status = STATUS_FAILURE
      end
    end

    update_attributes!(duration_in_seconds: duration, status: status)
  end
end
