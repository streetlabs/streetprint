class AddStyleToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :style, :string, :default => 'default'
  end

  def self.down
    remove_column :sites, :style
  end
end
