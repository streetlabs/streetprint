Feature: Session control
  In order to ensure my account is safe even if I forget to logout
  As a user of the site
  I want to be automatically logged out if inactive
  
  Scenario: session should expire after 45 minutes of inactivity
    Given I am logged in
    When I am inactive for 45 minutes
    Then I should not be logged in
