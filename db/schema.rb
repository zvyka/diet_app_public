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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120908182753) do

  create_table "announcements", :force => true do |t|
    t.text     "message"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tag"
    t.string   "title"
    t.integer  "ready"
  end

  create_table "credentials", :force => true do |t|
    t.string   "consumer_key"
    t.string   "shared_secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "foods", :force => true do |t|
    t.string  "name"
    t.float   "water"
    t.float   "calories"
    t.float   "protein"
    t.float   "lipid_total"
    t.float   "ash"
    t.float   "carbohydrates"
    t.float   "fiber"
    t.float   "sugar_total"
    t.float   "calcium"
    t.float   "iron"
    t.float   "magnesium"
    t.float   "phosphorus"
    t.float   "potassium"
    t.float   "sodium"
    t.float   "zinc"
    t.float   "copper"
    t.float   "manganese"
    t.float   "selenium"
    t.float   "vit_c"
    t.float   "thiamin"
    t.float   "riboflavin"
    t.float   "niacin"
    t.float   "panto_acid"
    t.float   "vit_b6"
    t.float   "folate_total"
    t.float   "folic_acid"
    t.float   "food_folate"
    t.float   "folate_dfe"
    t.float   "choline_total"
    t.float   "vit_b12"
    t.float   "vit_a_iu"
    t.float   "vit_a_rae"
    t.float   "retinol"
    t.float   "alpha_carotene"
    t.float   "beta_carotene"
    t.float   "beta_crypt"
    t.float   "lycopene"
    t.float   "lut_zea"
    t.float   "vit_e"
    t.float   "vit_d_mcg"
    t.float   "vit_d_iu"
    t.float   "vit_k"
    t.float   "fa_sat"
    t.float   "fa_mono"
    t.float   "fa_poly"
    t.float   "cholesterol"
    t.float   "weight_1_gms"
    t.string  "weight_1_desc"
    t.float   "weight_2_gms"
    t.string  "weight_2_desc"
    t.float   "refuse_pct"
    t.integer "umd",            :default => 0
    t.integer "user_id"
    t.boolean "delta",          :default => true, :null => false
  end

  create_table "ingredients", :force => true do |t|
    t.integer  "meal_id"
    t.string   "what_food"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "servings",              :precision => 4,  :scale => 2, :default => 1.0
    t.integer  "food_id"
    t.decimal  "serving_size",          :precision => 10, :scale => 0
    t.boolean  "fruits_and_vegetables",                                :default => false
  end

  create_table "meals", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.date     "date_eaten"
    t.integer  "location"
    t.decimal  "price",       :precision => 10, :scale => 0
    t.integer  "time_of_day"
    t.boolean  "favorite"
    t.string   "fave_name"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "grad_year"
    t.integer  "birth_year"
    t.string   "UID"
    t.boolean  "is_male"
    t.integer  "height"
    t.boolean  "is_special"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.integer  "group_id"
    t.integer  "id_num"
    t.integer  "weight"
    t.string   "reminder_freq",      :default => "0"
    t.integer  "activity_level",     :default => 0
    t.integer  "num_meals"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
