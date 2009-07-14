class AddReferencesToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :references, :text
  end

  def self.down
    remove_column :items, :references
  end
end
