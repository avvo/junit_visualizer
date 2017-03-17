class AddDurationToBuild < ActiveRecord::Migration[5.0]
  def change
    add_column :builds, :duration_in_seconds, :integer
    add_column :builds, :status, :string
  end
end
