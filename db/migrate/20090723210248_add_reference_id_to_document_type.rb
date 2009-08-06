class AddReferenceIdToDocumentType < ActiveRecord::Migration
  def self.up
    add_column :document_types, :reference_id, :integer
  end

  def self.down
    remove_column :document_types, :reference_id
  end
end
