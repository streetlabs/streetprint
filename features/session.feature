Feature: Session control
  In order to ensure my account is safe even if I forget to logout
  As a user of the site
  I want to be automatically logged out if inactive
  
  Scenario: session should expire after 10 minutes of inactivity
    Given I am logged in
    When I am inactive for 10 minutes
    Then I should not be logged in
