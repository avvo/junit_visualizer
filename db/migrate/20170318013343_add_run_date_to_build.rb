class AddRunDateToBuild < ActiveRecord::Migration[5.0]
  def change
    add_column :builds, :run_date, :datetime
  end
end
