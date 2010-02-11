class LocalPhoto < ActiveRecord::Base
  belongs_to :parent_photo, :class_name => :photo
  
  liquid_methods :original_url, :large_url, :thumb_url
  
  has_attached_file :photo, 
    :path => ":rails_root/public/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :url => "/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :styles => {
      :thumb => ["50x50#", :jpg],
      :large => ["550x420>", :jpg]
    }
  
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
