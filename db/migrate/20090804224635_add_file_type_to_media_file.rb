class AddFileTypeToMediaFile < ActiveRecord::Migration
  def self.up
    add_column :media_files, :file_type, :string
  end

  def self.down
    remove_column :media_files, :file_type
  end
end
