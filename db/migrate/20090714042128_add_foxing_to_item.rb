class AddFoxingToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :foxing, :string
  end

  def self.down
    remove_column :items, :foxing
  end
end
