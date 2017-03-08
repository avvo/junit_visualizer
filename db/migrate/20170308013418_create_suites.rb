class CreateSuites < ActiveRecord::Migration[5.0]
  def change
    create_table :suites do |t|
      t.references :project, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
