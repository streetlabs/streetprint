class AddFeaturedImageToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :featured_image, :integer
  end

  def self.down
    remove_column :sites, :featured_image
  end
end
