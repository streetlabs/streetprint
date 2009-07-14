class AddMarginaliaToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :marginalia, :string
  end

  def self.down
    remove_column :items, :marginalia
  end
end
