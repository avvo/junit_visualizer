class Testcase < ApplicationRecord
  belongs_to :project
  belongs_to :suite
  has_many :testcase_runs, dependent: :destroy

  validates_presence_of :project_id
  validates_presence_of :suite_id
  validates_presence_of :file_name
  validates_presence_of :name

  def last_test_run
    @last_test_run ||= testcase_runs.joins(:build).order('builds.number desc').first
  end

  def average_time(n = 100)
    testcase_runs.joins(:build).order('builds.number desc').limit(n).average(:time).round(2)
  end

  def average_pass(n = 100)
    (testcase_runs.joins(:build).order('builds.number desc').limit(n).group(:passed).select('sum(passed) / count(*) as pass_rate').first.pass_rate * 100).round(2)
  end

end
