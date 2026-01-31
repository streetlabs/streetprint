class LocalPhoto < ActiveRecord::Base
  belongs_to :parent_photo, :class_name => :photo

  # Liquid 4.0+ compatibility: define methods that should be accessible in Liquid templates
  def to_liquid
    {
      'original_url' => original_url,
      'large_url' => large_url,
      'thumb_url' => thumb_url
    }
  end

  has_attached_file :photo,
    :path => ":rails_root/public/system/local/:attachment/:rails_env/:id/:style/:basename.:extension",
    :url => "https://sp5-public.assets.streetprint.org/local/:attachment/:id/:style/:basename.:extension",
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
