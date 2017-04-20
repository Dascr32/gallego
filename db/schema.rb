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

ActiveRecord::Schema.define(version: 20170420201917) do

  create_table "learning_styles", force: :cascade do |t|
    t.string  "campus"
    t.integer "ca"
    t.integer "ec"
    t.integer "ea"
    t.integer "or"
    t.integer "ca_ec"
    t.integer "ea_or"
    t.string  "style"
  end

  create_table "professors", force: :cascade do |t|
    t.integer "age"
    t.string  "gender"
    t.string  "self_avaluation"
    t.integer "times_teaching"
    t.string  "background"
    t.string  "skills_with_pc"
    t.string  "exp_with_web_tech"
    t.string  "exp_with_web_sites"
    t.string  "category"
  end

  create_table "students", force: :cascade do |t|
    t.string  "gender"
    t.string  "campus"
    t.decimal "gpa"
    t.integer "ca"
    t.integer "ec"
    t.integer "ea"
    t.integer "or"
    t.integer "ca_ec"
    t.integer "ea_or"
    t.string  "style"
  end

end
