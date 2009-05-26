class Site < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :name, :user_id
  validates_length_of :name, :within => 5..20
  
end
