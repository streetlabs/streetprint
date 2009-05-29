Feature: Manage my site(s)
    In order to create a website to host my items
    As a regular user
    I want create and update a site
    
    Scenario: create a valid site
        Given I am logged in
          And I visit my account page
        When I follow "Create a site"
          And I fill in "Name" with "Mock Site"
          And I press "Create"
        Then I should see "Successfully created site"
    
    Scenario: fail when given invalid title
      Given I am logged in
        And I visit my account page
      When I follow "Create a site"
        And I fill in "Name" with "a"
        And I press "Create"
      Then I should see "Name is too short"
      
    Scenario: I should see my sites on my account page
        Given I am logged in
          And I have sites named "site_a, site_b"
          And I visit my account page
        Then I should see "site_a"
          And I should see "site_b"
        
    Scenario: I should be able to go to the site page from my account page
        Given I am logged in
          And I have sites named "site_a, site_b"
          And I visit my account page
          And I follow "site_a"
        Then I should be at the site page for "site_a"
        
    Scenario: I should be able to view my sites settings
      Given I am logged in
        And I have a site named "site_a"
      When I go to the site page for "site_a"
      Then I should see the site information for "site_a"
      
    Scenario: I should be able to edit a site
      Given I am logged in
        And I have a site named "site_a" with description "site_a description"
      When I go to the site page for "site_a"
        And I follow "edit"
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
    When I go to the site page for "site_a"
      And I follow "edit"
      And I fill in "name" with ""
      And I fill in "description" with "site_b description"
      And I press "Update"
    Then I should see "Name can't be blank"
