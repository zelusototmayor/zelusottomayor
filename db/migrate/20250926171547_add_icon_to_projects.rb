class AddIconToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :icon, :string
  end
end
