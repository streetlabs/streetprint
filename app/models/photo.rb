class Photo < ActiveRecord::Base
  belongs_to :item
  
  liquid_methods :original_url, :large_url, :thumb_url
  
  has_attached_file :photo, 
    :path => ":rails_root/public/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :url => "/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :styles => {
      :thumb => ["50x50#", :jpg],
      :large => ["550x420>", :jpg]
    }
    
  def self.destroy_pics(item_id, photos)  
    CloudfilePhoto.destroy_pics(item_id, photos)
    photos.each do |photo|
      file = Photo.find_by_id(photo, :conditions => { :item_id => item_id })
      file.destroy unless file == nil
    end
  end
  
  # if the photo has a cloudfile equivalent then get that instead
  alias :local_photo :photo
  def photo
    cloudfile = CloudfilePhoto.find_by_photo_id(self.id)
    if cloudfile
      return cloudfile.photo
    else
      return local_photo
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
