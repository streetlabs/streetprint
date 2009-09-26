class Category < ActiveRecord::Base
  belongs_to :site
  has_many :categorizations
  has_many :items, :through => :categorizations
  validates_presence_of :name, :site_id
  
  def to_liquid
    args = {}
    args['name'] = name.sanitize
    return args
  end
end
