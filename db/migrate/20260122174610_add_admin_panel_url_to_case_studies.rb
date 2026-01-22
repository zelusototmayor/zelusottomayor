class AddAdminPanelUrlToCaseStudies < ActiveRecord::Migration[8.0]
  def change
    add_column :case_studies, :admin_panel_url, :string
    add_column :case_studies, :tech_stack, :text
  end
end
