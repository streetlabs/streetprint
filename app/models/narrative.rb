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
  
  def first_image
    first_section = sections.first
    first_section && first_section.media && first_section.media.photos ? first_section.media.photos.first : nil
  end
  
  def to_liquid
    args = {}
    args['title'] = title.sanitize
    args['description'] = description.sanitize
    args['markdown'] = markdown?
    args['path'] = narrative_path(self)
    args['first_image'] = first_image if first_image.present?
    return args
  end
  
  def markdown?
    return markdown
  end

  def self.random_narrative(site)
    conditions = {}
    conditions[:site_id] = site.id
    Narrative.search( :order => "@random ASC", :conditions => conditions, :page => 1, :max_matches =>1, :per_page => 1).first
  end

end
