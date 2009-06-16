class Site < ActiveRecord::Base
  has_many :items
  has_many :authors
  has_many :categories
  belongs_to :user
  
  validates_presence_of :name, :user_id
  validates_length_of :name, :within => 5..20

end
