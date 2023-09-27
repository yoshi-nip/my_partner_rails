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

ActiveRecord::Schema[7.0].define(version: 2023_09_26_082450) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "day_articles", force: :cascade do |t|
    t.date "day"
    t.string "body"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day"], name: "index_day_articles_on_day", unique: true
    t.index ["user_id"], name: "index_day_articles_on_user_id"
  end

  create_table "habit_records", force: :cascade do |t|
    t.bigint "habit_id", null: false
    t.bigint "day_article_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_article_id"], name: "index_habit_records_on_day_article_id"
    t.index ["habit_id"], name: "index_habit_records_on_habit_id"
  end

  create_table "habits", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["start_date"], name: "index_habits_on_start_date", unique: true
    t.index ["user_id"], name: "index_habits_on_user_id"
  end

  create_table "monthly_articles", force: :cascade do |t|
    t.date "beginning_of_month"
    t.string "body"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["beginning_of_month"], name: "index_monthly_articles_on_beginning_of_month", unique: true
    t.index ["user_id"], name: "index_monthly_articles_on_user_id"
  end

  create_table "monthly_promises", force: :cascade do |t|
    t.date "month"
    t.string "body"
    t.string "if_then_plan"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["month"], name: "index_monthly_promises_on_month", unique: true
    t.index ["user_id"], name: "index_monthly_promises_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "weekly_articles", force: :cascade do |t|
    t.date "week"
    t.string "body"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_weekly_articles_on_user_id"
    t.index ["week"], name: "index_weekly_articles_on_week", unique: true
  end

  add_foreign_key "day_articles", "users"
  add_foreign_key "habit_records", "day_articles"
  add_foreign_key "habit_records", "habits"
  add_foreign_key "habits", "users"
  add_foreign_key "monthly_articles", "users"
  add_foreign_key "monthly_promises", "users"
  add_foreign_key "weekly_articles", "users"
end
