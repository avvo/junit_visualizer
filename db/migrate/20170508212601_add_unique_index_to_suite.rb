class AddUniqueIndexToSuite < ActiveRecord::Migration[5.0]
  def change
    add_index :suites, [:project_id, :name], :unique => true
  end
end
