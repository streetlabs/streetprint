class RemoveCategoryIdFromItem < ActiveRecord::Migration
  def self.up
    remove_column :items, :category_id
  end

  def self.down
  add_column :items, :category_id, :integer
  end
end
