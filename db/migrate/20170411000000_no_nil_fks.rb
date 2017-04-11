class NoNilFks < ActiveRecord::Migration[5.0]
  def change

    change_column :builds, :project_id, :integer, null: false
    change_column :suites, :project_id, :integer, null: false
    change_column :testcase_runs, :testcase_id, :integer, null: false
    change_column :testcase_runs, :build_id, :integer, null: false
    change_column :testcases, :project_id, :integer, null: false
    change_column :testcases, :suite_id, :integer, null: false

  end
end
