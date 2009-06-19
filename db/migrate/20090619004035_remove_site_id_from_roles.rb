class RemoveSiteIdFromRoles < ActiveRecord::Migration
  def self.up
    remove_column :roles, :site_id
  end

  def self.down
    add_column :roles, :site_id, :integer
  end
end
