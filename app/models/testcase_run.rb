class TestcaseRun < ApplicationRecord
  belongs_to :testcase
  belongs_to :build

  validates_presence_of :testcase_id
  validates_presence_of :time
  validates_presence_of :passed
  validates_presence_of :skipped
  validates_presence_of :build_id

end
