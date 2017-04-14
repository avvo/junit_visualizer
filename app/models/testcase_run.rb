class TestcaseRun < ApplicationRecord
  belongs_to :testcase
  belongs_to :build

  validates_presence_of :time

  def failed?
    [passed?, skipped?].none?
  end

end
