class AddSiteIdToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :site_id, :integer, :null => false
  end

  def self.down
    remove_column :items, :site_id
  end
end
