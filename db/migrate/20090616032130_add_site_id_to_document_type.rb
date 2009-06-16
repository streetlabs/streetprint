class AddSiteIdToDocumentType < ActiveRecord::Migration
  def self.up
    add_column :document_types, :site_id, :integer, :null => false
  end

  def self.down
    remove_column :document_types, :site_id
  end
end
