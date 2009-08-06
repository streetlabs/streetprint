class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :site
  validates_presence_of :site_id, :user_id
  validate :valid_user
  validate_on_create :unique_user
  
  def email=(email)
    user = User.find_by_email(email)
    unless user
      @invalid_user = email
    else 
      self.user = user
    end
  end
  
  def email
    self.user ? self.user.email : ''
  end
  
  private
  
    def valid_user
      if @invalid_user
        errors.add(:user, "with email #{@invalid_user} does not have an account yet.")
      end
    end
    
    def unique_user
      if(self.site && !self.site.users.blank? && (self.site.users.include? self.user))
        errors.add(:user, "is already a member")
      end
    end
end
