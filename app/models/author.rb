class Author < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :items
  has_many :authored
  has_many :items, :through => :authored
  belongs_to :site
  validates_presence_of :name, :site_id

  # Disable Sphinx indexing - use database queries instead
  # TODO: Upgrade to newer Sphinx version if search performance needed

  def to_liquid
    args = {}
    args['name'] = name.sanitize
    args['gender'] = gender.sanitize
    args['description'] = description.sanitize
    args['path'] = author_path(self)
    return args
  end
end
