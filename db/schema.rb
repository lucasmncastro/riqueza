# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 3) do

  create_table "movimentos", :force => true do |t|
    t.string   "titulo"
    t.text     "nota"
    t.date     "data"
    t.date     "data_prevista"
    t.float    "valor"
    t.string   "tipo"
    t.integer  "recorrencia_id"
    t.integer  "pai_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "movimentos_tags", :id => false, :force => true do |t|
    t.integer "movimento_id"
    t.integer "tag_id"
  end

  create_table "recorrencias", :force => true do |t|
    t.date     "data_inicial"
    t.string   "tipo"
    t.string   "intervalo"
    t.string   "dias_semana"
    t.integer  "dia_mes"
    t.integer  "repeticoes",   :default => 0
    t.date     "data_final"
    t.text     "parcelas"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end
