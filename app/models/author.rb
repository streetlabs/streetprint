class Author < ActiveRecord::Base
  include ActionController::UrlWriter
  
  has_many :items
  has_many :authored
  has_many :items, :through => :authored
  belongs_to :site
  validates_presence_of :name, :site_id
  
  def to_liquid
    args = {}
    args['name'] = name.sanitize
    args['gender'] = gender.sanitize
    args['description'] = description.sanitize
    args['path'] = author_path(self)
    return args
  end
end
