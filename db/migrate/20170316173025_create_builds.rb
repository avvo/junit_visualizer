class CreateBuilds < ActiveRecord::Migration[5.0]
  def change
    create_table :builds do |t|
      t.references :project, foreign_key: true
      t.integer :number

      t.timestamps
    end
  end
end
