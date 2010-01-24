class Author < ActiveRecord::Base
  include ActionController::UrlWriter
  
  has_many :items
  has_many :authored
  has_many :items, :through => :authored
  belongs_to :site
  validates_presence_of :name, :site_id
  
  define_index do
    indexes site_id
    indexes name, :sortable => true
    indexes gender, :sortable => true
    indexes description, :sortable => true

    has site_id, created_at, updated_at
    set_property :delta => true
  end
  
  def to_liquid
    args = {}
    args['name'] = name.sanitize
    args['gender'] = gender.sanitize
    args['description'] = description.sanitize
    args['path'] = author_path(self)
    return args
  end
end
