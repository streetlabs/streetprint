class AddPublisherDetailsToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :publisher_details, :text
  end

  def self.down
    remove_column :items, :publisher_details
  end
end
