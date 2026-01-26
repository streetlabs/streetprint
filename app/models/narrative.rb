class Narrative < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  # Rails 4.2: :order option replaced with lambda scope
  has_many :sections, -> { order("order_number ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :sections, :allow_destroy => true
  belongs_to :site
  validates_presence_of :title, :site_id

  # Disable Sphinx indexing - use database queries instead
  # TODO: Upgrade to newer Sphinx version if search performance needed

  def first_image
    first_section = sections.first
    first_section && first_section.media && first_section.media.photos ? first_section.media.photos.first : nil
  end

  def to_liquid
    args = {}
    args['title'] = title
    args['description'] = description
    args['markdown'] = markdown?
    args['path'] = narrative_path(self)
    args['first_image'] = first_image&.to_liquid
    return args
  end

  def markdown?
    return markdown
  end

  def self.random_narrative(site)
    # Use database query instead of Sphinx for Docker environment
    # Rails 4.2: Use new finder syntax
    Narrative.where(:site_id => site.id).order("RAND()").limit(1).first
  end

end
