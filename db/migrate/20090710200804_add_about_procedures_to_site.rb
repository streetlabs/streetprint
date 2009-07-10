class AddAboutProceduresToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :about_procedures, :text
  end

  def self.down
    remove_column :sites, :about_procedures
  end
end
