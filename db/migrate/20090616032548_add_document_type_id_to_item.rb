class AddDocumentTypeIdToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :document_type_id, :integer
  end

  def self.down
    remove_column :items, :document_type_id
  end
end
