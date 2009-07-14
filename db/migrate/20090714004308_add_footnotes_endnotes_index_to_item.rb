class AddFootnotesEndnotesIndexToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :footnotes, :text
    add_column :items, :endnotes, :text
    add_column :items, :index, :string
  end

  def self.down
    remove_column :items, :index
    remove_column :items, :endnotes
    remove_column :items, :footnotes
  end
end
