class AddApprovedToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :approved, :boolean, :default => false, nil => false
  end

  def self.down
    remove_column :sites, :approved
  end
end
