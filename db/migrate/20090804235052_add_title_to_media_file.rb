class AddTitleToMediaFile < ActiveRecord::Migration
  def self.up
    add_column :media_files, :title, :string
  end

  def self.down
    remove_column :media_files, :title
  end
end
