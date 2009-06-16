class DocumentType < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :site_id
  has_many :items
end
