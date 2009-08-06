class RemoveOldAuthorizationTables < ActiveRecord::Migration
	def self.up
		drop_table :roles
		remove_column :memberships, :owner
		remove_column :memberships, :role_id
	end

	def self.down
	  add_column :memberships, :role_id, :integer,                       :null => false
	  add_column :memberships, :owner, :boolean,      :default => false
		create_table "roles", :force => true do |t|
			t.string	 "name"
			t.text		 "description"
			t.datetime "created_at"
			t.datetime "updated_at"
		end
		
	end
end
