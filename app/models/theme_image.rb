class ThemeImage < ActiveRecord::Base
  belongs_to :site_theme

  # add site_theme_id to paperclip interpolations
  # kt-paperclip uses Paperclip.interpolates instead of Paperclip::Attachment.interpolations
  Paperclip.interpolates :site_theme_id do |attachment, style|
    attachment.instance.site_theme_id
  end

  has_attached_file :image,
    :path => ":rails_root/public/system/:attachment/:rails_env/:site_theme_id/:style/:basename.:extension",
    :url => "/system/:attachment/:rails_env/:site_theme_id/:style/:basename.:extension"

  # Override Paperclip's url method to return S3 URLs in development
  def image
    attachment = super
    if Rails.env.development?
      # Monkey patch the url method on this specific attachment instance
      class << attachment
        def url(style = :original, use_timestamp = true)
          return nil unless @instance.image_file_name
          s3_base = "https://sp5-public.assets.streetprint.org"
          style_path = style.to_sym == :original ? "original" : style.to_s
          "#{s3_base}/images/#{@instance.site_theme_id}/#{style_path}/#{@instance.image_file_name}"
        end
      end
    end
    attachment
  end

end
