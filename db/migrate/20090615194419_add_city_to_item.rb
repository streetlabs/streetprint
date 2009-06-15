class AddCityToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :city, :string
  end

  def self.down
    remove_column :items, :city
  end
end
