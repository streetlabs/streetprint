class Site < ActiveRecord::Base
  has_many :items
  has_many :authors
  has_many :categories
  has_many :document_types
  has_many :memberships
  has_many :news_posts
  has_many :users, :through => :memberships
  
  validates_presence_of :name
  validates_length_of :name, :within => 5..35
  validate :valid_users
  
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
    text = text.split("\n\n").map { |p| "<p>" + p + "</p>" }.join
    text = text.split("\n").join("<br />")
  end
  
  def about_procedures_for_display
    text = about_procedures
    text = text.split("\n\n").map { |p| "<p>" + p + "</p>" }.join
    text = text.split("\n").join("<br />")
  end
  
  private
    def valid_users
      errors.add(:users, "user with email '#{@invalid_user}' does not exist") if @invalid_user
    end
    
end
