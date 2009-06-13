class RemoveAuthorIdFromItem < ActiveRecord::Migration
  def self.up
    remove_column :items, :author_id
  end

  def self.down
    add_column :items, :author_id, :integer
  end
end
