class AddCustomGenericFormsToSite < ActiveRecord::Migration
  def self.up
    add_column "sites", "generic_forms", :boolean, :default => false
  end

  def self.down
    remove_column "sites", "generic_forms"
  end
end
