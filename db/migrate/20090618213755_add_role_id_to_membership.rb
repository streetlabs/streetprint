class AddRoleIdToMembership < ActiveRecord::Migration
  def self.up
    add_column :memberships, :role_id, :integer, :null => false
  end

  def self.down
    remove_column :memberships, :role_id
  end
end
