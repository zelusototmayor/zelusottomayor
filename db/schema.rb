# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_01_07_193428) do
  create_table "case_studies", force: :cascade do |t|
    t.string "name", null: false
    t.string "client_name"
    t.integer "client_type", default: 0, null: false
    t.text "tagline"
    t.text "problem"
    t.text "approach"
    t.text "results"
    t.text "metrics"
    t.string "hero_image"
    t.string "thumbnail"
    t.string "link"
    t.string "icon"
    t.string "slug", null: false
    t.boolean "featured", default: false
    t.integer "display_order", default: 0
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_type"], name: "index_case_studies_on_client_type"
    t.index ["display_order"], name: "index_case_studies_on_display_order"
    t.index ["featured"], name: "index_case_studies_on_featured"
    t.index ["published_at"], name: "index_case_studies_on_published_at"
    t.index ["slug"], name: "index_case_studies_on_slug", unique: true
  end

  create_table "contact_submissions", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "company"
    t.string "project_type"
    t.string "budget_range"
    t.string "timeline"
    t.text "message", null: false
    t.integer "status", default: 0, null: false
    t.string "referral_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_contact_submissions_on_created_at"
    t.index ["email"], name: "index_contact_submissions_on_email"
    t.index ["status"], name: "index_contact_submissions_on_status"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon"
  end

  create_table "testimonials", force: :cascade do |t|
    t.string "client_name", null: false
    t.string "client_title"
    t.string "client_company"
    t.text "content", null: false
    t.string "avatar"
    t.integer "rating", default: 5
    t.boolean "featured", default: false
    t.integer "display_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["display_order"], name: "index_testimonials_on_display_order"
    t.index ["featured"], name: "index_testimonials_on_featured"
  end
end
