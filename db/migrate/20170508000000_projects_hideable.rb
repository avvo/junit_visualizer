class ProjectsHideable < ActiveRecord::Migration[5.0]

  def change

    add_column :projects, :hide, :boolean, default: false, null: false

  end

end
