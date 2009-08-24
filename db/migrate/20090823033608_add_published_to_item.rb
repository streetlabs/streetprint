class AddPublishedToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :published, :boolean, :default => false
  end

  def self.down
    remove_column :items, :published
  end
end
