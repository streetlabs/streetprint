class AddFieldsToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :reference_number, :string
    add_column :items, :date, :datetime
    add_column :items, :date_details, :string
    add_column :items, :dimensions, :string
    add_column :items, :pagination, :string
    add_column :items, :illustrations, :string
    add_column :items, :location, :string
    add_column :items, :notes, :text
  end

  def self.down
    remove_column :items, :notes
    remove_column :items, :location
    remove_column :items, :illustrations
    remove_column :items, :pagination
    remove_column :items, :dimensions
    remove_column :items, :date_details
    remove_column :items, :date
    remove_column :items, :reference_number
  end
end
