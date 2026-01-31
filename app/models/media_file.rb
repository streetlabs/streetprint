class MediaFile < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  belongs_to :item

  has_attached_file :file,
    :path => ":rails_root/public/system/:attachment/:rails_env/:id/:basename.:extension",
    :url => "https://sp5-public.assets.streetprint.org/:attachment/:id/:basename.:extension"

  def to_liquid
    vars = {}
    vars['display_name'] = display_name if display_name
    vars['path'] = file.url
    vars
  end

  def self.destroy_files(item_id, media_files)
    media_files.each do |media_file|
      file = MediaFile.find_by_id(media_file, :conditions => { :item_id => item_id })
      file.destroy unless file == nil
    end
  end

  def display_name
    title.blank? ? file_file_name : title
  end
end
