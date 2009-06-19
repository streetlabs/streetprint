class AddSiteIdToRole < ActiveRecord::Migration
  def self.up
    add_column :roles, :site_id, :integer
  end

  def self.down
    remove_column :roles, :site_id
  end
end
