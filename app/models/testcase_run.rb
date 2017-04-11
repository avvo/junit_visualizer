class TestcaseRun < ApplicationRecord
  belongs_to :testcase
  belongs_to :build

  validates_presence_of :time
  validates_presence_of :passed
  validates_presence_of :skipped

end
