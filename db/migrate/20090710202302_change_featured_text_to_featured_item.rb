class ChangeFeaturedTextToFeaturedItem < ActiveRecord::Migration
  def self.up
    remove_column :sites, :featured_text
    add_column :sites, :featured_item, :integer
  end

  def self.down
    remove_column :sites, :featured_item
    add_column :sites, :featured_text, :integer
  end
end
