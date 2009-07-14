class AddPriceToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :price, :text
  end

  def self.down
    remove_column :items, :price
  end
end
