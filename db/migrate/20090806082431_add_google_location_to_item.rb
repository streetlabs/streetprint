class AddGoogleLocationToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :google_location, :string
  end

  def self.down
    remove_column :items, :google_location
  end
end
