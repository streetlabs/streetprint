class AddAdvertisementsToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :advertisements, :text
  end

  def self.down
    remove_column :items, :advertisements
  end
end
