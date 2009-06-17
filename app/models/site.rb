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
  
  def users_list=(users_list)
    users_list.delete('-1')
    current_users = self.users.map { |u| u.email }
    to_delete = (current_users - users_list).uniq
    to_add = (users_list - current_users).uniq

    to_delete.each do |user_email|
      self.users.delete(User.find_by_email(user_email))
    end
    to_add.each do |user_email|
      next if user_email.blank?
      user = User.find_by_email(user_email)
      raise ArgumentError, user_email unless user
      self.users << User.find_by_email(user_email)
    end
  rescue ArgumentError => e
    @invalid_user = e.message
  end


  private
    def valid_users
      errors.add(:users, "user with email '#{@invalid_user}' does not exist") if @invalid_user
    end
end
