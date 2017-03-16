class TestcaseRun < ApplicationRecord
  belongs_to :testcase
  belongs_to :build
end
