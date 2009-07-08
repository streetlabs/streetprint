class AddImageIdToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :image_id, :integer
  end

  def self.down
    remove_column :photos, :image_id
  end
end
