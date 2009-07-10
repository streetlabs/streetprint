class AddAboutProjectToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :about_project, :text
  end

  def self.down
    remove_column :sites, :about_project
  end
end
