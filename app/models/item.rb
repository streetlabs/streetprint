class Item < ActiveRecord::Base
  has_many :photos, :dependent => :destroy
  belongs_to :site
  validates_presence_of :title, :site_id

  define_index do
    indexes title, :sortable => true
    has site_id, created_at, updated_at
    set_property :delta => true
  end
  
  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
    end
  end
end
