class AddAuthoridToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :author_id, :integer
  end

  def self.down
    remove_column :items, :author_id
  end
end
