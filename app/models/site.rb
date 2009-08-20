class Site < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :authors, :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :document_types, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :news_posts, :dependent => :destroy
  has_many :users, :through => :memberships
  
  
  validates_presence_of :title
  validates_uniqueness_of :title
  validates_format_of :title, :with => /^[A-Za-z0-9.]+$/, :message => "can only contain A-Z, a-z, 0-9, and periods (.)"
  validates_length_of :title, :within => 6..35
  restricted_titles = YAML::load(File.open("#{RAILS_ROOT}/config/subdomain_restrictions.yml"))
  validates_exclusion_of :title, :in => restricted_titles, :message => "title %s is not allowed"
  
  validates_presence_of :name
  validates_length_of :name, :within => 5..100
  validate :valid_users
  
  has_attached_file :logo, 
    :path => ":rails_root/public/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :url => "/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :default_url => "/system/:attachment/missing_:style.png",
    :styles => {
      :small => ["60x60#", :png]
    }
  
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
    
end
