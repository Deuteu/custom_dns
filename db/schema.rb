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

ActiveRecord::Schema.define(version: 20170920193900) do

  create_table "dns_records", force: :cascade do |t|
    t.string "cloudflare_dns_id"
    t.string "cloudflare_dns_type"
    t.string "cloudflare_dns_name"
    t.string "ping_token"
    t.index ["ping_token"], name: "index_dns_records_on_ping_token"
  end

  create_table "tg_users", force: :cascade do |t|
    t.string "telegram_id"
    t.boolean "is_bot"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "language_code"
    t.index ["telegram_id"], name: "index_tg_users_on_telegram_id"
  end

end
