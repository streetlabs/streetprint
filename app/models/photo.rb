class Photo < ActiveRecord::Base
  belongs_to :item
  has_one :local_photo, :dependent => :destroy
  has_one :cloudfile_photo, :dependent => :destroy

  # Liquid 4.0+ compatibility: define methods that should be accessible in Liquid templates
  def to_liquid
    {
      'original_url' => original_url,
      'large_url' => large_url,
      'thumb_url' => thumb_url
    }
  end

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

  # Return a mock Paperclip attachment object that uses our S3 URLs
  def photo
    @photo_wrapper ||= PhotoUrlWrapper.new(self)
  end

  # Wrapper class to make photo.url(:style) work with S3
  class PhotoUrlWrapper
    def initialize(photo)
      @photo = photo
    end

    def url(style = :original)
      case style.to_sym
      when :thumb
        @photo.thumb_url
      when :large
        @photo.large_url
      when :original
        @photo.original_url
      else
        @photo.original_url
      end
    end

    # Handle photo.url without arguments
    def url(*args)
      style = args.first || :original
      case style.to_sym
      when :thumb
        @photo.thumb_url
      when :large
        @photo.large_url
      else
        @photo.original_url
      end
    end

    # Return nil for missing photos
    def nil?
      @photo.original_url.nil?
    end
  end

  def original_url
    cloudfile = CloudfilePhoto.find_by_photo_id(self.id)
    return cloudfile.original_url if cloudfile
    return LocalPhoto.find_by_photo_id(self.id).original_url if LocalPhoto.find_by_photo_id(self.id)
  end

  def large_url
    cloudfile = CloudfilePhoto.find_by_photo_id(self.id)
    return cloudfile.large_url if cloudfile
    return LocalPhoto.find_by_photo_id(self.id).large_url if LocalPhoto.find_by_photo_id(self.id)
  end

  def thumb_url
    cloudfile = CloudfilePhoto.find_by_photo_id(self.id)
    return cloudfile.thumb_url if cloudfile
    return LocalPhoto.find_by_photo_id(self.id).thumb_url if LocalPhoto.find_by_photo_id(self.id)
  end

end
