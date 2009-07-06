class AddCaptionAndOrderToPhoto < ActiveRecord::Migration
  def self.up
    add_column :photos, :caption, :string
    add_column :photos, :order, :integer
  end

  def self.down
    remove_column :photos, :order
    remove_column :photos, :caption
  end
end
