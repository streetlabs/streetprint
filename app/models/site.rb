class Site < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :authors, :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :document_types, :dependent => :destroy
  has_many :custom_data_types, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :narratives, :dependent => :destroy
  has_many :news_posts, :dependent => :destroy
  has_many :users, :through => :memberships

  belongs_to :site_theme

  validates_presence_of :title
  validates_uniqueness_of :title
  # Rails 4.2 requires \A and \z instead of ^ and $ for security
  validates_format_of :title, :with => /\A[A-Za-z0-9.]+\z/, :message => "can only contain A-Z, a-z, 0-9, and periods (.)"
  validates_length_of :title, :within => 6..35
  restricted_titles = YAML::load(File.open("#{Rails.root}/config/subdomain_restrictions.yml"))
  validates_exclusion_of :title, :in => restricted_titles, :message => "title %s is not allowed"
  validates_presence_of :name
  validates_length_of :name, :within => 5..100
  validate :valid_users

  # Rails 4.2 requires lambda syntax for scopes
  scope :approved, -> { where(:approved => true) }

  before_create :assign_default_theme

  has_attached_file :logo,
    :path => ":rails_root/public/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :url => "https://sp5-public.assets.streetprint.org/:attachment/:id/:style/:basename.:extension",
    :default_url => "/missing_icons/:attachment/missing_:style.png",
    :styles => {
      :small => ["60x60#", :png],
      :small_wide => ["125x50#", :png]
    }

  # S3 URL helper - returns S3 URL for logos stored on asset server
  def logo_s3_url(style = :original)
    return logo.url(style) unless logo_file_name
    s3_base = "https://sp5-public.assets.streetprint.org"
    style_path = style == :original ? "original" : style.to_s

    # Paperclip converts to PNG for styled versions, so change extension
    filename = if style == :original
      logo_file_name
    else
      # Replace extension with .png since styles specify :png format
      logo_file_name.sub(/\.[^.]+$/, '.png')
    end

    "#{s3_base}/logos/#{id}/#{style_path}/#{filename}"
  end

  def to_liquid
     vars = {}
     vars['id'] = id
     vars['name'] = name
     vars['title'] = title
     vars['logo_url'] = logo_s3_url(:small_wide) if logo_file_name
     vars['logo_small_url'] = logo_s3_url(:small) if logo_file_name

     # Debug welcome_blurb with detailed logging
     if welcome_blurb
       Rails.logger.debug "=" * 80
       Rails.logger.debug "Site#to_liquid for #{name} (ID: #{id})"
       Rails.logger.debug "  welcome_blurb from DB:"
       Rails.logger.debug "    Class: #{welcome_blurb.class}"
       Rails.logger.debug "    Length: #{welcome_blurb.length}"
       Rails.logger.debug "    Encoding: #{welcome_blurb.encoding}"
       Rails.logger.debug "    Full content: #{welcome_blurb.inspect}"

       converted = welcome_blurb.to_s.force_encoding('UTF-8')
       Rails.logger.debug "  After conversion:"
       Rails.logger.debug "    Class: #{converted.class}"
       Rails.logger.debug "    Length: #{converted.length}"
       Rails.logger.debug "    Encoding: #{converted.encoding}"
       Rails.logger.debug "    Full content: #{converted.inspect}"
       Rails.logger.debug "=" * 80

       vars['welcome_blurb'] = converted
     end

     vars['about_procedures'] = about_procedures.to_s.force_encoding('UTF-8') if about_procedures
     vars['about_project'] = about_project.to_s.force_encoding('UTF-8') if about_project
     vars['theme'] = site_theme_id
     vars['narratives'] = narratives.map(&:to_liquid)
     vars
   end

  def Site.any(number_of_sites)
    # Rails 4.2: Use new finder syntax
    Site.limit(number_of_sites)
  end

  def random_item
    Item.random_item(self)
  end

  def random_narrative
    Narrative.random_narrative(self)
  end

  def owner?(user)
    return false unless self.memberships.find_by_user_id(user.id)
    self.memberships.find_by_user_id(user.id).owner?
  end

  def generic_forms?
    return self.generic_forms
  end

  def about_project_for_display
    text = about_project
    return '' unless text
    text = text.split("\n\n").map { |p| "<p>" + p + "</p>" }.join
    text = text.split("\n").join("<br />")
  end

  def about_procedures_for_display
    text = about_procedures
    return '' unless text
    text = text.split("\n\n").map { |p| "<p>" + p + "</p>" }.join
    text = text.split("\n").join("<br />")
  end

  def item_title
    return self.plural_item.capitalize unless !self.plural_item
  end

  private
    def valid_users
      errors.add(:users, "user with email '#{@invalid_user}' does not exist") if @invalid_user
    end

    def assign_default_theme
      # Rails 4.2: Use new finder syntax
      self.site_theme ||= SiteTheme.where(:user_id => nil, :name => "Default").first
    end

end
