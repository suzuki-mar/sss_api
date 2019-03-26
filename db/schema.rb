# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_25_075825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "problem_solvings", force: :cascade do |t|
    t.date "log_date"
    t.boolean "is_draft", null: false
    t.text "problem_recognition"
    t.text "example_problem"
    t.text "cause"
    t.text "phenomenon"
    t.text "neglect_phenomenon"
    t.text "solution"
    t.text "execution_method"
    t.text "evaluation_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reframings", force: :cascade do |t|
    t.date "log_date"
    t.text "problem_reason"
    t.text "objective_facts"
    t.string "feeling"
    t.integer "before_point", limit: 2
    t.integer "distortion_group", limit: 2
    t.text "reframing"
    t.text "action_plan"
    t.integer "after_point", limit: 2
    t.boolean "is_draft", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "self_care_classifications", force: :cascade do |t|
    t.integer "status_group", limit: 2, null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "self_cares", force: :cascade do |t|
    t.date "log_date", null: false
    t.integer "am_pm", limit: 2, null: false
    t.integer "point", limit: 2, null: false
    t.text "reason", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "self_care_classification_id"
    t.index ["self_care_classification_id"], name: "index_self_cares_on_self_care_classification_id"
  end

  add_foreign_key "self_cares", "self_care_classifications"
end
