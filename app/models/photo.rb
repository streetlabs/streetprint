class Photo < ActiveRecord::Base
  belongs_to :item
  has_one :local_photo, :dependent => :destroy
  has_one :cloudfile_photo, :dependent => :destroy
  
  liquid_methods :original_url, :large_url, :thumb_url
  
  # destroy and cloudfiles or localphotos first then destroy photo
  def self.destroy_pics(item_id, photos)
    photos.each do |photo|
      file = Photo.find_by_id(photo, :conditions => { :item_id => item_id })
      localfile = LocalPhoto.find_by_photo_id(file.id)
      cloudfile = CloudfilePhoto.find_by_photo_id(file.id)
      localfile.destroy unless localfile == nil
      cloudfile.destroy unless cloudfile == nil
      file.destroy unless file == nil
    end
  end
  
  # assign to appropriate photo based on cloudfile settings
  def photo=(p)
    if(StreetprintSettings.use_cloudfiles?)
      cloudfile = self.build_cloudfile_photo
      cloudfile.photo = p
    else
      localphoto = self.build_local_photo
      localphoto.photo = p
    end
  end
  
  # return cloudfile photo if one exists, else local photo
  def photo
    cloudfile = CloudfilePhoto.find_by_photo_id(self.id)
    if cloudfile
      return cloudfile.photo
    else
      return LocalPhoto.find_by_photo_id(self.id).photo
    end
  end
  
  def original_url
    self.photo.url
  end
  def large_url
    self.photo.url(:large)
  end
  def thumb_url
    self.photo.url(:thumb)
  end
  
end
