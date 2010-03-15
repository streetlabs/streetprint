class Narrative < ActiveRecord::Base
  include ActionController::UrlWriter
  
  has_many :sections, :dependent => :destroy, :order => "order_number ASC"
  accepts_nested_attributes_for :sections, :allow_destroy => true
  belongs_to :site
  validates_presence_of :title, :site_id
  
  define_index do
    indexes site_id
    indexes title, :sortable => true
    indexes description, :sortable => true

    has site_id, created_at, updated_at
  end
  
  def to_liquid
    args = {}
    args['title'] = title.sanitize
    args['description'] = description.sanitize
    args['markdown'] = markdown?
    args['path'] = narrative_path(self)
    return args
  end
  
  def markdown?
    return markdown
  end
  
end
