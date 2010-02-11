class RemoveUneededFieldsFromPhoto < ActiveRecord::Migration
  def self.up
    remove_column :photos, :photo_file_name
    remove_column :photos, :photo_content_type
    remove_column :photos, :photo_file_size
    remove_column :photos, :photo_updated_at
  end

  def self.down
    add_column :photos, :photo_file_name
    add_column :photos, :photo_content_type
    add_column :photos, :photo_file_size
    add_column :photos, :photo_updated_at
  end
end
