class AddPublisherToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :publisher, :string
  end

  def self.down
    remove_column :items, :publisher
  end
end
