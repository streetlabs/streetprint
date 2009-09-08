class AddSiteThemeIdToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :site_theme_id, :integer
  end

  def self.down
    remove_column :sites, :site_theme_id
  end
end
