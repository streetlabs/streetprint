class AddDescriptionToMediaFile < ActiveRecord::Migration
  def self.up
    add_column :media_files, :description, :text
  end

  def self.down
    remove_column :media_files, :description
  end
end
