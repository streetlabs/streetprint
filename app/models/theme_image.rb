class ThemeImage < ActiveRecord::Base
  belongs_to :site_theme
  # add site_theme_id to paperclip interpolations
  Paperclip::Attachment.interpolations[:site_theme_id] = proc do |attachment, style| 
    attachment.instance.site_theme_id
  end
  has_attached_file :image,
    :path => ":rails_root/public/system/:attachment/:rails_env/:site_theme_id/:style/:basename.:extension",
    :url => "/system/:attachment/:rails_env/:site_theme_id/:style/:basename.:extension"
    
end
