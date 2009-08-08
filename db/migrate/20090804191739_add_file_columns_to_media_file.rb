class AddFileColumnsToMediaFile < ActiveRecord::Migration
  def self.up
    add_column :media_files, :file_file_name, :string
    add_column :media_files, :file_content_type, :string
    add_column :media_files, :file_file_sieze, :integer
    add_column :media_files, :file_updated_at, :datetime
  end

  def self.down
    remove_column :media_files, :file_updated_at
    remove_column :media_files, :file_file_sieze
    remove_column :media_files, :file_content_type
    remove_column :media_files, :file_file_name
  end
end
