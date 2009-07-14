class AddItemBindingToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :item_binding, :string
  end

  def self.down
    remove_column :items, :item_binding
  end
end
