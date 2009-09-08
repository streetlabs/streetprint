class DocumentType < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :site_id
  has_many :items
  
  def to_liquid
    args = {}
    args['name'] = name.sanitize
    return args
  end
end
