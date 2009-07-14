class AddGenderToAuthor < ActiveRecord::Migration
  def self.up
    add_column :authors, :gender, :text
  end

  def self.down
    remove_column :authors, :gender
  end
end
