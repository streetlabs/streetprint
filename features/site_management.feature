Feature: Manage my site(s)
    In order to create a website to host my items
    As a regular user
    I want create and update a site
    
    Scenario: create a valid site
        Given I am logged in
          And I go to my account page
        When I follow "Create a site"
          And I fill in "Name" with "Mock Site"
          And I press "Create"
        Then I should see "Successfully created site"
    
    Scenario: fail when given invalid title
      Given I am logged in
        And I go to my account page
      When I follow "Create a site"
        And I fill in "Name" with "a"
        And I press "Create"
      Then I should see "Name is too short"
      
    Scenario: I should see my sites on my account page
        Given I am logged in
          And I have sites named "site_a, site_b"
          And I go to my account page
        Then I should see "site_a"
          And I should see "site_b"
        
    Scenario: I should be able to go to the site page from my account page
        Given I am logged in
          And I have sites named "site_a, site_b"
          And I go to my account page
          And I follow "Show" for site "site_a"
        Then I should be at the site page for "site_a"
        
    Scenario: I should be able to view my site
      Given I am logged in
        And I have a site named "site_a"
      When I go to the site page for "site_a"
      Then I should see the site information for "site_a"
      
    Scenario: My site page should show my first item or a note that there are not items
      Given I am logged in
        And I have a site named "site_a"
      When I go to the site page for "site_a"
      Then I should see "This site doesn't have any items yet"
        
      Given "site_a" has an item "item_1"
        And "item_1" has 3 photos
      When I go to the site page for "site_a"
      Then the page should contain the item info
      
    Scenario: Site page has next and previous item links
      Given I am logged in
        And I have a site named "site_a"
      When I go to the site page for "site_a"
      Then I should not see "Next item"
        And I should not see "Previous item"
      
      Given "site_a" has an item "item_1"
        And "site_a" has an item "item_2"
        And "site_a" has an item "item_3"
      When I go to the site page for "site_a"
      Then I should see "Next item"
        And I should not see "Previous item"
        And the page should contain the item info for "item_1"
      When I follow "Next item"
      Then I should see "Previous item"
        And I should see "Next item"
        And the page should contain the item info for "item_2"
      When I follow "Next item"
      Then I should not see "Next item"
        And I should see "Previous item"
        And the page should contain the item info for "item_3"
        
      
    Scenario: I should be able to edit a site
      Given I am logged in
        And I have a site named "site_a" with description "site_a description"
      When I go to my account page
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
        When I go to my account page
        And I follow "Edit Items" for site "site_a"
      Then I should be on the items page for "site_a"