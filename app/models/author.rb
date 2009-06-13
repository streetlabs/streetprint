class Author < ActiveRecord::Base
  has_many :items
  has_many :authored
  has_many :items, :through => :authored
  belongs_to :site
  validates_presence_of :name, :site_id
end
