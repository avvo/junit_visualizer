class Testcase < ApplicationRecord
  belongs_to :project
  belongs_to :suite
  has_many :testcase_runs, dependent: :destroy
end
