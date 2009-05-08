class Item < ActiveRecord::Base
  has_many :photos
  validates_presence_of :title
  
  def photo_attributes=(photo_attributes)
    photo_attributes.each do |attributes|
      photos.build(attributes)
    end
  end
end
