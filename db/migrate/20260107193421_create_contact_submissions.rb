class CreateContactSubmissions < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_submissions do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :company
      t.string :project_type
      t.string :budget_range
      t.string :timeline
      t.text :message, null: false
      t.integer :status, default: 0, null: false
      t.string :referral_source

      t.timestamps
    end

    add_index :contact_submissions, :email
    add_index :contact_submissions, :status
    add_index :contact_submissions, :created_at
  end
end
