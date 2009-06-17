class RemoveUserIdFromSite < ActiveRecord::Migration
  def self.up
    remove_column :sites, :user_id
  end

  def self.down
    add_column :sites, :user_id, :integer
  end
end
