class AddUniqueIndexToBuild < ActiveRecord::Migration[5.0]
  def change
    add_index :builds, [:project_id, :number], :unique => true
  end
end
