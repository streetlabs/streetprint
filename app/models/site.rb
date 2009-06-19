class Site < ActiveRecord::Base
  has_many :items
  has_many :authors
  has_many :categories
  has_many :document_types
  has_many :memberships
  has_many :users, :through => :memberships
  
  validates_presence_of :name
  validates_length_of :name, :within => 5..20
  validate :valid_users
  
  def owner?(user)
    return false unless self.memberships.find_by_user_id(user.id)
    self.memberships.find_by_user_id(user.id).owner?
  end
  
  def role_of(user)
    self.memberships.find_by_user_id(user.id).role.name
  end

  private
    def valid_users
      errors.add(:users, "user with email '#{@invalid_user}' does not exist") if @invalid_user
    end
    
end
