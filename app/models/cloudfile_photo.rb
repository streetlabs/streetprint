class CloudfilePhoto < ActiveRecord::Base
  belongs_to :item
  
  liquid_methods :original_url, :large_url, :thumb_url
  
  has_attached_file :photo,                     # 
                      :styles => {
                        :thumb => ["50x50#", :jpg],
                        :large => ["550x420>", :jpg]
                      },
                    :storage => :cloud_files,
                    :cloudfiles_credentials => "#{RAILS_ROOT}/config/rackspace_cloudfiles.yml"
    
  def self.destroy_pics(item, photos)
    photos.each do |photo|
      file = CloudfilePhoto.find_by_photo_id(photo)
      file.destroy unless file == nil
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
