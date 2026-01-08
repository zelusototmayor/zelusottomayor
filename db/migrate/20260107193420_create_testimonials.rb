class CreateTestimonials < ActiveRecord::Migration[8.0]
  def change
    create_table :testimonials do |t|
      t.string :client_name, null: false
      t.string :client_title
      t.string :client_company
      t.text :content, null: false
      t.string :avatar
      t.integer :rating, default: 5
      t.boolean :featured, default: false
      t.integer :display_order, default: 0

      t.timestamps
    end

    add_index :testimonials, :featured
    add_index :testimonials, :display_order
  end
end
