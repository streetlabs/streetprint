class AddTitleAndBlurbToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :title, :string
    add_column :sites, :welcome_blurb, :text
  end

  def self.down
    remove_column :sites, :welcome_blurb
    remove_column :sites, :title
  end
end
