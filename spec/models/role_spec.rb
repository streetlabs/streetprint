require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Role do

  it "should create a new instance given valid attributes" do
    Role.create!(Factory.attributes_for(:role))
  end
  
  it "should require a name" do
    role = Factory.build(:role, :name => nil)
    role.should have(1).error_on(:name)
  end
  
end