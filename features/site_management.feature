Feature: Manage my site(s)
    In order to create a website to host my items
    As a regular user
    I want create and update a site
    
    Scenario: should be able to assign all required site field
      Given I am logged in
        And I go to the sites page
      When I follow "create a site"
        And I fill in "Title" with "Mock Site"
        And I fill in "Name" with "Mock site: name"
        And I fill in "description" with "a mock site"
        And I fill in "welcome blurb" with "This is the welcome message to mock site"
        And I press "create"
      Then I should see "Successfully created site"
      
      When I go to the site page for "Mock site: name"
        Then I should see each of "Mock site: name, This is the welcome message to mock site"
    
    Scenario: create a valid site
      Given I am logged in
        And I go to the sites page
      When I follow "Create a site"
        And I fill in "Name" with "Mock Site"
        And I press "Create"
      Then I should see "Successfully created site"
  
    Scenario: friendly error if admin role is missing
      Given I am logged in
        And I go to the sites page
        And the 'admin' role is missing
      When I follow "Create a site"
        And I fill in "Name" with "Mock Site"
        And I press "Create"
      Then I should see "Failed to add user with admin role. Please contact site administrator."
        
        
    Scenario: fail when given invalid title
      Given I am logged in
        And I go to the sites page
      When I follow "Create a site"
        And I fill in "Name" with "a"
        And I press "Create"
      Then I should see "Name is too short"
      
    Scenario: I should see my sites on the sites page
        Given I am logged in
          And I have sites named "site_a, site_b"
          And I go to the sites page
        Then I should see "site_a"
          And I should see "site_b"
        
    Scenario: I should be able to go to the site page from my account page
        Given I am logged in
          And I have sites named "site_a, site_b"
          And I go to the sites page
          And I follow "Show" for site "site_a"
        Then I should be at the site page for "site_a"
        
    Scenario: I should be able to view my site
      Given I am logged in
        And I have a site named "site_a"
      When I go to the site page for "site_a"
      Then I should see the site information for "site_a"
            
    Scenario: I should be able to edit a site
      Given I am logged in
        And I have a site named "site_a" with description "site_a description"
      When I go to the sites page
        And I follow "Edit Site" for site "site_a"
        And I fill in "name" with "site_b"
        And I fill in "description" with "site_b description"
        And I press "Update"
        And I go to the sites page
      Then I should not see "site_a"
      
      When I go to the site page for "site_b"
      Then I should see the site information for "site_b"
      
    Scenario: friendly notice when error editing site
      Given I am logged in
        And I have a site named "site_a" with description "site_a description"
      When I go to the edit site page for "site_a"
        And I fill in "name" with ""
        And I fill in "description" with "site_b description"
        And I press "Update"
      Then I should see "Name can't be blank"
      
    Scenario: navigate to the sites items page
      Given I am logged in
        And I have a site named "site_a"
      When I go to the sites page
        And I follow "Edit Items" for site "site_a"
      Then I should be on the items page for "site_a"
      
    Scenario: should get edit links for site/item if I am logged in and viewing my site/item
      Given I am logged in
        And I have a site named "site_a"
        And "site_a" has an item "item_1"
      When I go to the site page for "site_a"
      
      When I follow "Edit this site"
      Then I should be on the edit site page for "site_a"
      
      Given I am on the item page for "item_1" in "site_a"
      When I follow "Edit this item"
      Then I should be on the edit item page for "item_1" in "site_a"