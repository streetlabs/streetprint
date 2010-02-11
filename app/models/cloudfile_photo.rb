class CloudfilePhoto < ActiveRecord::Base
  belongs_to :parent_photo, :class_name => :photo
  
  liquid_methods :original_url, :large_url, :thumb_url
  
  has_attached_file :photo,
    :styles => {
        :thumb => ["50x50#", :jpg],
        :large => ["550x420>", :jpg]
      },
    :storage => :cloud_files,
    :cloudfiles_credentials => StreetprintSettings.cloudfiles_credentials
                    
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
