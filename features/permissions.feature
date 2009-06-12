Feature: Site Permissions
  In order to keep my information private
  As a site owner
  I want to keep others from seeing my information
  
  Scenario: The account page should not be accessible when logged out
    Given I have an account with email "user@example.com"
    When I visit the account page for "user@example.com"
    Then I should see "You must be logged in"
      And I should be on the login page
  
  Scenario: The site pages should not be accessible when logged out
    When I go to the sites page
    Then I should see "You must be logged in"
    
    
  Scenario: Sites are specific to users
    Given I am logged in as "user@example.com"
      And I have sites named "site_a, site_b"
    When I go to the sites page
    Then I should see "site_a"
      And I should see "site_b"
    
    Given I log out
    
    Given I am logged in as "other_user@example.com"
    When I go to the sites page
    Then I should not see "site_a"
      And I should not see "site_b"
      
  Scenario: Should not be able to edit others sites
    Given I am logged in as "user@example.com"
      And I have a site named "site_a"
      And I log out
    
    Given I am logged in as "other_user@example.com"
    When I go to the site page for "site_a"
    Then I should not see "Edit"
    
    When I go to the edit site page for "site_a"
    Then I should see "You do not have permission to access this page"
    
  Scenario: Should not be able to edit items on others sites
    Given I am logged in as "user@example.com"
      And I have a site named "site_a"
      And "site_a" has an item with title "mock item"
      And I log out
    
    Given I am logged in as "other_user@example.com"
    When I go to the items page for "site_a"
    Then I should not see "Edit"
      And I should not see "Destroy"
      And I should not see "New Item"
      
    When I go to the item page for "mock item" in "site_a"
    Then I should not see "Edit"
      And I should not see "Destroy"
      
      
  Scenario: Should not see edit links for site/items if not logged in as the site owner
    Given I am logged in as "user@example.com"
      And I have a site named "site_a"
      And "site_a" has an item with title "mock item"
      And I log out
    
    Given I am logged in as "other_user@example.com"
    When I go to the site page for "site_a"
    Then I should not see "Edit this site"
      And I should not see "Edit this item"