class CreateTestcases < ActiveRecord::Migration[5.0]
  def change
    create_table :testcases do |t|
      t.references :project, foreign_key: true
      t.references :suite, foreign_key: true
      t.string :file_name
      t.string :name

      t.timestamps
    end
  end
end
