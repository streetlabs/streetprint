class AddFineprintToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :fine_print, :text
  end

  def self.down
    remove_column :sites, :fine_print
  end
end
