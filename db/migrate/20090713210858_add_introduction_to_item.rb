class AddIntroductionToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :introduction, :text
  end

  def self.down
    remove_column :items, :introduction
  end
end
