class SiteTheme < ActiveRecord::Base
  belongs_to :user

  has_one :show_site_template, :dependent => :destroy
  has_one :show_narrative_template, :dependent => :destroy
  has_one :show_about_template, :dependent => :destroy
  has_one :show_news_posts_template, :dependent => :destroy
  has_one :show_artifact_template, :dependent => :destroy
  has_one :browse_artifacts_template, :dependent => :destroy
  has_one :index_artifacts_template, :dependent => :destroy
  has_one :index_narratives_template, :dependent => :destroy
  has_one :show_author_template, :dependent => :destroy
  has_one :show_full_text_template, :dependent => :destroy
  has_one :show_google_location_template, :dependent => :destroy
  has_one :layout_template, :dependent => :destroy

  has_many :theme_images, :dependent => :destroy

  validates_presence_of :name

  # Rails 4.2 requires lambda syntax for scopes
  scope :global, -> { where(:user_id => nil) }

  after_create :set_defaults_if_not_specified

  has_attached_file :icon,
    :path => ":rails_root/public/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :url => "https://sp5-public.assets.streetprint.org/:attachment/:id/:style/:basename.:extension",
    :default_url => "/missing_icons/:attachment/missing_:style.png",
    :styles => {
      :small => ["80x80#", :png]
    }

  # S3 URL helper - returns S3 URL for icons stored on asset server
  def icon_s3_url(style = :original)
    return icon.url(style) unless icon_file_name
    s3_base = "https://sp5-public.assets.streetprint.org"
    style_path = style == :original ? "original" : style.to_s

    # Paperclip converts to PNG for styled versions, so change extension
    filename = if style == :original
      icon_file_name
    else
      # Replace extension with .png since styles specify :png format
      icon_file_name.sub(/\.[^.]+$/, '.png')
    end

    "#{s3_base}/icons/#{id}/#{style_path}/#{filename}"
  end

  def to_liquid
    h = {}
    h[:images_base_path] = images_base_path
    h
  end

  def image=(image)
    theme_images.build(:image => image)
  end

  def image_attributes=(image_attributes)
    for attributes in image_attributes
      theme_images.build(attributes)
    end
  end

  def delete_image=(delete_image)
    theme_images.find(delete_image.to_i).destroy
  end

  def images_base_path
    "https://sp5-public.assets.streetprint.org/images/#{id}/original/"
  end

  private
    def set_defaults_if_not_specified
      [
        [:layout_template,                LayoutTemplate],
        [:show_site_template,             ShowSiteTemplate],
        [:show_about_template,            ShowAboutTemplate],
        [:show_narrative_template,        ShowNarrativeTemplate],
        [:show_news_posts_template,       ShowNewsPostsTemplate],
        [:show_artifact_template,         ShowArtifactTemplate],
        [:browse_artifacts_template,      BrowseArtifactsTemplate],
        [:index_artifacts_template,       IndexArtifactsTemplate],
        [:index_narratives_template,      IndexNarrativesTemplate],
        [:show_author_template,           ShowAuthorTemplate],
        [:show_full_text_template,        ShowFullTextTemplate],
        [:show_google_location_template,  ShowGoogleLocationTemplate]
      ].each do |template, cls|
        if self.send(template).nil?
          tp = cls.new
          tp.site_theme = self
          tp.template = File.read(File.join(Rails.root, 'config', 'themes', 'Default', template.to_s[0..-10], 'template.liquid'))
          tp.css = File.read(File.join(Rails.root, 'config', 'themes', 'Default', template.to_s[0..-10], 'css.css'))
          tp.save!
        end
      end
    end

end
