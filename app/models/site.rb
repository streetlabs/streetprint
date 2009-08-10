class Site < ActiveRecord::Base
  has_many :items, :dependent => :destroy
  has_many :authors, :dependent => :destroy
  has_many :categories, :dependent => :destroy
  has_many :document_types, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :news_posts, :dependent => :destroy
  has_many :users, :through => :memberships
  
  validates_presence_of :name
  validates_length_of :name, :within => 5..35
  validate :valid_users
  
  has_attached_file :logo, 
    :path => ":rails_root/public/system/:attachment/:rails_env/:id/:style/:basename.:extension",
    :url => "/system/:attachment/:rails_env/:id/:style/:basename.:extension",
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
  
  def role_of(user)
    self.memberships.find_by_user_id(user.id).role.name
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
