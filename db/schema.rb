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

ActiveRecord::Schema.define(version: 20170508000000) do

  create_table "builds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "project_id",          null: false
    t.integer  "number"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "duration_in_seconds"
    t.string   "status"
    t.datetime "run_date"
    t.index ["project_id"], name: "index_builds_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "hide",       default: false, null: false
  end

  create_table "suites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "project_id", null: false
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_suites_on_project_id", using: :btree
  end

  create_table "testcase_runs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "testcase_id",               null: false
    t.float    "time",        limit: 24
    t.boolean  "passed"
    t.boolean  "skipped"
    t.text     "full_error",  limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "build_id",                  null: false
    t.index ["build_id"], name: "index_testcase_runs_on_build_id", using: :btree
    t.index ["testcase_id"], name: "index_testcase_runs_on_testcase_id", using: :btree
  end

  create_table "testcases", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "project_id", null: false
    t.integer  "suite_id",   null: false
    t.string   "file_name"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_testcases_on_project_id", using: :btree
    t.index ["suite_id"], name: "index_testcases_on_suite_id", using: :btree
  end

  add_foreign_key "builds", "projects"
  add_foreign_key "suites", "projects"
  add_foreign_key "testcase_runs", "builds"
  add_foreign_key "testcase_runs", "testcases"
  add_foreign_key "testcases", "projects"
  add_foreign_key "testcases", "suites"
end
