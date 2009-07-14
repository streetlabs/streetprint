class AddProvenanceToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :provenance, :string
  end

  def self.down
    remove_column :items, :provenance
  end
end
