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
    