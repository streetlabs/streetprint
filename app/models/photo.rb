class Photo < ActiveRecord::Base
  belongs_to :item
  
  has_attached_file :photo, 
    :path => ":rails_root/public/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :url => "/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :styles => {
      :thumb => "50x50>",
      :large => "640x480>"
    }
    
  def self.destroy_pics(item, photos)
    Photo.find(photos, :conditions => { :item_id => item }).each(&:destroy)
  end
end
