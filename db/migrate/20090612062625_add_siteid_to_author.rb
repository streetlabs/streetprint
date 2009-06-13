class AddSiteidToAuthor < ActiveRecord::Migration
  def self.up
    add_column :authors, :site_id, :integer
  end

  def self.down
    remove_column :authors, :site_id
  end
end
