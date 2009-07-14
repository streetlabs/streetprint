class AddTemplateFieldsToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :seller, :string
    add_column :items, :seller_details, :text
    add_column :items, :printer, :string
    add_column :items, :printer_details, :text
    add_column :items, :binder, :string
    add_column :items, :binder_details, :text
  end

  def self.down
    remove_column :items, :binder_details
    remove_column :items, :binder
    remove_column :items, :printer_details
    remove_column :items, :printer
    remove_column :items, :seller_details
    remove_column :items, :seller
  end
end
