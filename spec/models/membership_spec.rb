require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Membership do

  it "should create a new instance given valid attributes" do
    user = Factory.create(:user)
    site = Factory.create(:site)
    membership = Membership.create!(Factory.attributes_for(:membership, :user_id => user.id, :site_id => site.id))
  end
    
  it "shoud require a user and site" do
    membership = Factory.build(:membership)
    membership.should have(1).error_on(:site_id)
    membership.should have(1).error_on(:user_id)
  end
  
  it "should be able to get all memberships/users from a site and memberships/sites from user" do
    user1 = Factory.create(:user)
    user2 = Factory.create(:user)
    user3 = Factory.create(:user)
    site1 = Factory.create(:site)
    site2 = Factory.create(:site)
    site3 = Factory.create(:site)
    membership1 = Membership.create!(Factory.attributes_for(:membership, :user_id => user1.id, :site_id => site1.id))
    membership2 = Membership.create!(Factory.attributes_for(:membership, :user_id => user2.id, :site_id => site1.id))
    membership3 = Membership.create!(Factory.attributes_for(:membership, :user_id => user3.id, :site_id => site2.id))
    membership4 = Membership.create!(Factory.attributes_for(:membership, :user_id => user2.id, :site_id => site2.id))
    membership5 = Membership.create!(Factory.attributes_for(:membership, :user_id => user1.id, :site_id => site3.id))

    user1.sites.should include(site1)
    user1.sites.should include(site3)
    user2.sites.should include(site1)
    user2.sites.should include(site2)
    user3.sites.should include(site2)
                              
    site1.users.should include(user1)
    site1.users.should include(user2)
    site2.users.should include(user2)
    site2.users.should include(user3)
    site3.users.should include(user1)
    
    site1.memberships.count.should == 2
    site2.memberships.count.should == 2
    site3.memberships.count.should == 1
                    
    user1.memberships.count.should == 2
    user2.memberships.count.should == 2
    user3.memberships.count.should == 1
    
  end
end