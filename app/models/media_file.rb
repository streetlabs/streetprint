class MediaFile < ActiveRecord::Base
  belongs_to :item

  has_attached_file :file, 
    :path => ":rails_root/public/system/:attachment/:rails_env/:id/:basename.:extension",
    :url => "/system/:attachment/:rails_env/:id/:basename.:extension"

  def self.destroy_media_files(item, media_files)
    MediaFile.find(media_files, :conditions => { :item_id => item }).each(&:destroy)
  end
  
  def display_name
    title.blank? ? file_file_name : title
  end
end
