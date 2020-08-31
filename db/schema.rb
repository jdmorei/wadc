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

ActiveRecord::Schema.define(version: 20200831155932) do

  create_table "dispositivos", force: :cascade do |t|
    t.string   "tipo"
    t.string   "fabricante"
    t.string   "serie"
    t.string   "modelo"
    t.string   "nombre"
    t.date     "fecha"
    t.text     "descripcion"
    t.string   "ip"
    t.string   "passenable"
    t.string   "passtelnet"
    t.string   "passsh"
    t.integer  "usuario_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "consoleconfig"
    t.integer  "telnetport"
    t.integer  "sshport"
    t.string   "username"
  end

  add_index "dispositivos", ["usuario_id"], name: "index_dispositivos_on_usuario_id"

  create_table "interfaces", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "mask"
    t.string   "gateway"
    t.string   "dns"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "macros", force: :cascade do |t|
    t.string   "fabricante"
    t.string   "serie"
    t.string   "modelo"
    t.string   "inputs"
    t.string   "commands"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "nombre"
    t.string   "version"
    t.string   "via"
    t.string   "osversion"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "rol"
    t.integer  "superusuario"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
