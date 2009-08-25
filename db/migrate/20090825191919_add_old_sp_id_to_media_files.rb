class AddOldSpIdToMediaFiles < ActiveRecord::Migration
  def self.up
    add_column :media_files, :old_sp_id, :integer
  end

  def self.down
    remove_column :media_files, :old_sp_id
  end
end
