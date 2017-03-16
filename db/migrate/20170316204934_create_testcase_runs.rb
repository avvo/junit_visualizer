class CreateTestcaseRuns < ActiveRecord::Migration[5.0]
  def change
    create_table :testcase_runs do |t|
      t.references :testcase, foreign_key: true
      t.float :time
      t.boolean :passed
      t.boolean :skipped
      t.text :full_error

      t.timestamps
    end
  end
end
