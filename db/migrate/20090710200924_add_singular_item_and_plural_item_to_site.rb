class AddSingularItemAndPluralItemToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :singular_item, :string
    add_column :sites, :plural_item, :string
  end

  def self.down
    remove_column :sites, :plural_item
    remove_column :sites, :singular_item
  end
end
