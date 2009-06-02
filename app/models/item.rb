class Item < ActiveRecord::Base
  has_many :photos, :dependent => :destroy
  belongs_to :site
  validates_presence_of :title, :site_id
  
  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
    end
  end
end
