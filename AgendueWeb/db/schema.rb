# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150402164805) do

  create_table "devices", force: true do |t|
    t.string   "os"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "helps", force: true do |t|
    t.string   "title"
    t.text     "content",    limit: 255
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "user"
    t.string   "subject"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "projectid"
  end

  create_table "notifications", force: true do |t|
    t.string   "message"
    t.string   "device_token"
    t.string   "notification_os"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "subject"
  end

  create_table "personal_tasks", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "complete"
    t.integer  "userid"
    t.datetime "duedate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "label"
  end

  create_table "premium_users", force: true do |t|
    t.string   "name"
    t.boolean  "admin_init"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.integer  "projectid"
    t.string   "users"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shares"
    t.string   "allshares"
    t.text     "wiki"
    t.boolean  "public"
  end

  create_table "tasks", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.date     "duedate"
    t.date     "personalduedate"
    t.boolean  "complete"
    t.integer  "taskid"
    t.integer  "projectid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "assignedto"
    t.datetime "datecomplete"
    t.integer  "label"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "userid"
    t.string   "projectids"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "paiduntil"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "stripeid"
    t.boolean  "premium"
    t.boolean  "currentSubscriber"
    t.string   "facebook"
    t.boolean  "noemail"
    t.datetime "premiumuntil"
    t.boolean  "cancelPremium"
    t.string   "deviceids"
    t.boolean  "premiumoverride"
    t.string   "google_picture"
    t.string   "primary_color"
    t.string   "secondary_color"
    t.string   "tertiary_color"
    t.boolean  "share_calendar"
    t.string   "muted_projects"
  end

end
