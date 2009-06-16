class Category < ActiveRecord::Base
  belongs_to :site
  has_many :items
  validates_presence_of :name, :site_id
  
end
