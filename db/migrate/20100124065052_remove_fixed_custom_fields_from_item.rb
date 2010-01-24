class RemoveFixedCustomFieldsFromItem < ActiveRecord::Migration

  def self.up
    remove_column :items, :introduction
    remove_column :items, :publisher_details
    remove_column :items, :seller
    remove_column :items, :seller_details
    remove_column :items, :printer
    remove_column :items, :printer_details
    remove_column :items, :binder
    remove_column :items, :binder_details
    remove_column :items, :price
    remove_column :items, :serialized
    remove_column :items, :footnotes
    remove_column :items, :endnotes
    remove_column :items, :index
    remove_column :items, :advertisements
    remove_column :items, :edges
    remove_column :items, :foxing
    remove_column :items, :provenance
    remove_column :items, :marginalia
    remove_column :items, :summary_of_contents
    remove_column :items, :references
    remove_column :items, :item_binding 
  end
  
  def self.down
    raise ActiveRecord::IrreversibleMigration
  end

end
