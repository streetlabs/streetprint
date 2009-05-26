require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  it "should create a new instance given valid attributes" do
    user = User.create!(Factory.attributes_for(:user))
  end
  
  it "should not be active at time of creation" do
    user = User.create!(Factory.attributes_for(:user))
    user.should_not be_active
  end
  
  it "should error if password doesn't match confirmation'" do
    user = Factory.build(:user, :password_confirmation => "sceret")
    user.should_not be_valid
  end
  
end