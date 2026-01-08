class CreateCaseStudies < ActiveRecord::Migration[8.0]
  def change
    create_table :case_studies do |t|
      t.string :name, null: false
      t.string :client_name
      t.integer :client_type, default: 0, null: false
      t.text :tagline
      t.text :problem
      t.text :approach
      t.text :results
      t.text :metrics
      t.string :hero_image
      t.string :thumbnail
      t.string :link
      t.string :icon
      t.string :slug, null: false
      t.boolean :featured, default: false
      t.integer :display_order, default: 0
      t.datetime :published_at

      t.timestamps
    end

    add_index :case_studies, :slug, unique: true
    add_index :case_studies, :client_type
    add_index :case_studies, :featured
    add_index :case_studies, :published_at
    add_index :case_studies, :display_order
  end
end
