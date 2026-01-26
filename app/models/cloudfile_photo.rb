class CloudfilePhoto < ActiveRecord::Base
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
    :styles => {
        :thumb => ["50x50#", :jpg],
        :large => ["550x420>", :jpg]
      },
    :storage => :cloud_files,
    :cloudfiles_credentials => StreetprintSettings.cloudfiles_credentials

  # S3 Configuration
  S3_BASE_URL = "https://sp5-public.assets.streetprint.org"

  # Override URL methods to point to S3
  # Path uses CloudfilePhoto.id (this record's ID)
  def original_url
    return nil unless photo_file_name
    "#{S3_BASE_URL}/photos/#{id}/original/#{photo_file_name}"
  end

  def large_url
    return nil unless photo_file_name
    "#{S3_BASE_URL}/photos/#{id}/large/#{s3_filename}"
  end

  def thumb_url
    return nil unless photo_file_name
    "#{S3_BASE_URL}/photos/#{id}/thumb/#{s3_filename}"
  end

  private

  # Convert .tif extensions to .jpg since Paperclip processed them
  # Also downcase the file extension only
  def s3_filename
    filename = photo_file_name
    # If it's a TIF/TIFF file, Paperclip converted it to JPG
    if filename =~ /\.(tif|tiff)$/i
      filename.sub(/\.(tif|tiff)$/i, '.jpg')
    else
      # Downcase only the extension
      filename.sub(/\.([^.]+)$/) { |ext| ext.downcase }
    end
  end
end
