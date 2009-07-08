class AddTextIdToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :text_id, :integer
  end

  def self.down
    remove_column :items, :text_id
  end
end
