class AddEdgesToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :edges, :string
  end

  def self.down
    remove_column :items, :edges
  end
end
