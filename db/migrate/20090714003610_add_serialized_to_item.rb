class AddSerializedToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :serialized, :boolean
  end

  def self.down
    remove_column :items, :serialized
  end
end
