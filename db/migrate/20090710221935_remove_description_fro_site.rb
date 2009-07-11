class RemoveDescriptionFroSite < ActiveRecord::Migration
  def self.up
    remove_column :sites, :description
  end

  def self.down
    add_column :sites, :description, :text
  end
end
