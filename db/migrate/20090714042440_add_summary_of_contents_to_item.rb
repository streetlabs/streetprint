class AddSummaryOfContentsToItem < ActiveRecord::Migration
  def self.up
    add_column :items, :summary_of_contents, :string
  end

  def self.down
    remove_column :items, :summary_of_contents
  end
end
