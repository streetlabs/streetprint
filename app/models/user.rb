class User < ActiveRecord::Base
  acts_as_authorization_subject
  has_many :memberships
  has_many :site_themes
  has_many :sites, :through => :memberships
  attr_accessible :email, :password, :password_confirmation
  
  acts_as_authentic do |c|
    c.login_field = :email
    c.logged_in_timeout = 45.minutes
    
  end
  
  def active?
    active
  end  
  
  def activate!
    self.active = true
    save
  end

  # Email notification
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end
  
end
