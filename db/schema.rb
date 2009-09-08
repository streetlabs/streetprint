# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090908070822) do

  create_table "authoreds", :force => true do |t|
    t.integer  "author_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id"
    t.text     "gender"
  end

  create_table "browse_artifacts_templates", :force => true do |t|
    t.integer  "site_theme_id"
    t.text     "template"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
  end

  create_table "categorizations", :force => true do |t|
    t.integer  "category_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id",      :null => false
    t.integer  "reference_id"
  end

  create_table "index_artifacts_templates", :force => true do |t|
    t.integer  "site_theme_id"
    t.text     "template"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_id",                                :null => false
    t.boolean  "delta",               :default => true,  :null => false
    t.string   "reference_number"
    t.datetime "date"
    t.string   "date_details"
    t.string   "dimensions"
    t.string   "pagination"
    t.string   "illustrations"
    t.string   "location"
    t.text     "notes"
    t.string   "publisher"
    t.string   "city"
    t.integer  "document_type_id"
    t.text     "full_text"
    t.integer  "text_id"
    t.text     "introduction"
    t.text     "publisher_details"
    t.string   "seller"
    t.text     "seller_details"
    t.string   "printer"
    t.text     "printer_details"
    t.string   "binder"
    t.text     "binder_details"
    t.text     "price"
    t.boolean  "serialized"
    t.text     "footnotes"
    t.text     "endnotes"
    t.string   "index"
    t.text     "advertisements"
    t.string   "edges"
    t.string   "foxing"
    t.string   "provenance"
    t.string   "marginalia"
    t.string   "summary_of_contents"
    t.text     "references"
    t.string   "item_binding"
    t.string   "google_location"
    t.integer  "year"
    t.integer  "month"
    t.integer  "day"
    t.boolean  "published",           :default => false
  end

  create_table "layout_templates", :force => true do |t|
    t.integer  "sp_template_id"
    t.text     "template"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "site_theme_id"
  end

  create_table "media_files", :force => true do |t|
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_sieze"
    t.datetime "file_updated_at"
    t.string   "file_type"
    t.string   "title"
    t.text     "description"
    t.integer  "old_sp_id"
  end

  add_index "media_files", ["item_id"], :name => "index_media_files_on_item_id"

  create_table "memberships", :force => true do |t|
    t.integer  "site_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "caption"
    t.integer  "order"
    t.integer  "image_id"
  end

  add_index "photos", ["item_id"], :name => "index_photos_on_item_id"

  create_table "roles", :force => true do |t|
    t.string   "name",              :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "show_about_templates", :force => true do |t|
    t.integer  "site_theme_id"
    t.text     "template"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "show_artifact_templates", :force => true do |t|
    t.integer  "site_theme_id"
    t.text     "template"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "show_author_templates", :force => true do |t|
    t.integer  "site_theme_id"
    t.text     "template"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "show_full_text_templates", :force => true do |t|
    t.integer  "site_theme_id"
    t.text     "template"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "show_google_location_templates", :force => true do |t|
    t.integer  "site_theme_id"
    t.text     "template"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "show_news_posts_templates", :force => true do |t|
    t.integer  "site_theme_id"
    t.text     "template"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "show_site_templates", :force => true do |t|
    t.integer  "site_theme_id"
    t.text     "template"
    t.text     "css"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_themes", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sites", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.text     "welcome_blurb"
    t.integer  "featured_image"
    t.text     "about_project"
    t.text     "about_procedures"
    t.string   "singular_item"
    t.string   "plural_item"
    t.text     "fine_print"
    t.integer  "featured_item"
    t.string   "style",             :default => "default"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.boolean  "approved",          :default => false
    t.integer  "site_theme_id"
  end

  create_table "theme_images", :force => true do |t|
    t.integer  "site_theme_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                  :null => false
    t.string   "crypted_password",                       :null => false
    t.string   "password_salt",                          :null => false
    t.string   "persistence_token",                      :null => false
    t.string   "single_access_token",                    :null => false
    t.string   "perishable_token",                       :null => false
    t.integer  "login_count",         :default => 0,     :null => false
    t.integer  "failed_login_count",  :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",              :default => false, :null => false
  end

end
