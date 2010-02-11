class CreateLocalPhotos < ActiveRecord::Migration
  def self.up
    create_table :local_photos do |t|
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "photo_file_name"
      t.string   "photo_content_type"
      t.integer  "photo_file_size"
      t.datetime "photo_updated_at"
      
      t.integer  "photo_id"

      t.timestamps
    end
    add_index :local_photos, :photo_id
  end

  def self.down
    drop_table :local_photos
  end
end
