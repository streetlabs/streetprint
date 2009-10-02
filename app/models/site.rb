class Site < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :authors, :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :document_types, :dependent => :destroy
  has_many :custom_data_types, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :news_posts, :dependent => :destroy
  has_many :users, :through => :memberships
  
  belongs_to :site_theme
    
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_format_of :title, :with => /^[A-Za-z0-9.]+$/, :message => "can only contain A-Z, a-z, 0-9, and periods (.)"
  validates_length_of :title, :within => 6..35
  restricted_titles = YAML::load(File.open("#{RAILS_ROOT}/config/subdomain_restrictions.yml"))
  validates_exclusion_of :title, :in => restricted_titles, :message => "title %s is not allowed"
  validates_presence_of :name
  validates_length_of :name, :within => 5..100
  validate :valid_users
  
  named_scope :approved, :conditions => {:approved => true}
  
  before_create :assign_default_theme
  
  has_attached_file :logo, 
    :path => ":rails_root/public/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :url => "/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :default_url => "/missing_icons/:attachment/missing_:style.png",
    :styles => {
      :small => ["60x60#", :png],
      :small_wide => ["125x50#", :png]
    }
    
  def to_liquid
     vars = {}
     vars['id'] = id
     vars['name'] = name.sanitize
     vars['title'] = title.sanitize
     vars['welcome_blurb'] = welcome_blurb.sanitize
     vars['about_procedures'] = about_procedures.sanitize
     vars['about_project'] = about_project.sanitize
     vars['theme'] = site_theme_id
     vars
   end
  
  def Site.any(number_of_sites)
    Site.find(:all, :limit => number_of_sites)
  end
  
  def owner?(user)
    return false unless self.memberships.find_by_user_id(user.id)
    self.memberships.find_by_user_id(user.id).owner?
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
      self.site_theme ||= SiteTheme.find(:all, :conditions => {:user_id => nil, :name => "Default"}).first
    end
    
end
