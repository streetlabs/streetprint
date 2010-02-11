class RemoveUneededFieldsFromCloudfilePhoto < ActiveRecord::Migration
  def self.up
    remove_column :cloudfile_photos, :item_id
    remove_column :cloudfile_photos, :caption
    remove_column :cloudfile_photos, :order
  end

  def self.down
    add_column :cloudfile_photos, :item_id
    add_column :cloudfile_photos, :caption
    add_column :cloudfile_photos, :order
  end
end
