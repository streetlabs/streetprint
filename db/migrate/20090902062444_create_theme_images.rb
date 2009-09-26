class CreateThemeImages < ActiveRecord::Migration
  def self.up
    create_table :theme_images do |t|
      t.integer :site_theme_id

      #paperclip fields
      t.string   :image_file_name
      t.string   :image_content_type
      t.integer  :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :theme_images
  end
end
