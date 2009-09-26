class CreateSiteThemes < ActiveRecord::Migration
  def self.up
    create_table :site_themes do |t|
      t.string :name
      t.integer :user_id
      
      #paperclip fields
      t.string   :icon_file_name
      t.string   :icon_content_type
      t.integer  :icon_file_size
      t.datetime :icon_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :site_themes
  end
end
