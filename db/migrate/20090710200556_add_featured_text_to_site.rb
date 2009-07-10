class AddFeaturedTextToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :featured_text, :integer
  end

  def self.down
    remove_column :sites, :featured_text
  end
end
