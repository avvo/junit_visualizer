class AddBuildToTestcaseRuns < ActiveRecord::Migration[5.0]
  def change
    add_reference :testcase_runs, :build, foreign_key: true
  end
end
