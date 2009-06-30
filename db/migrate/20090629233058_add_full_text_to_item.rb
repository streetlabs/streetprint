class AddFullTextToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :full_text, :text
  end

  def self.down
    remove_column :items, :full_text
  end
end
