class LongerTestcaseData < ActiveRecord::Migration[5.1]
  def change
    change_column :testcases, :name, :string, limit: 2048
    change_column :testcases, :file_name, :string, limit: 2048
  end
end
