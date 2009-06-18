class AddOwnerToMembership < ActiveRecord::Migration
  def self.up
    add_column :memberships, :owner, :boolean, :default => false
  end

  def self.down
    remove_column :memberships, :owner
  end
end
