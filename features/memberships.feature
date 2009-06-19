Feature: User membership with site
  In order allow multiple people to work on a site
  As a site user
  I want to be able to give other users permissions to change my site
  
  Scenario: should be able to edit a users role
    Given the following users
      |email|
      |joe@example.com|
      
    Given I am logged in
      And I have site named "site_a"
      And "site_a" has the user "joe@example.com" with role "admin"
    When I go to the edit membership page for "joe@example.com" in "site_a"
      And I select "editor" from "membership_role_id"
      And I press "Submit"
    Then I should see "Successfully updated membership."
      And "site_a" should have user "joe@example.com" with role "editor"

  Scenario: Should give an error if invalid user
    Given I am logged in
      And I have a site named "site_a"
    When I go to the new membership page for "site_a"
      And I fill in "email" with "unreal_user@example.com"
      And I press "Submit"
    Then I should see each of "error, unreal_user@example.com does not have an account"

  Scenario: Should be able to remove a user
    Given the following users
    |email|
    |joe@example.com|
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has the user "joe@example.com"
    When I go to the memberships page for "site_a"
      And I follow "remove"
    Then "site_a" should not have the user "joe@example.com"


  Scenario: Should not be able to remove the owner from a site
    Given I am logged in
      And I have a site named "site_a"
    When I go to the memberships page for "site_a"
    Then I should not see "Remove"
    
  Scenario: get error when adding user who already is a member
    Given the following users
    |email|
    |joe@example.com|

    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has the user "joe@example.com"
    When I go to the new membership page for "site_a"
      And I fill in "email" with "joe@example.com"
      And I press "Submit"
    Then I should see each of "error, already a member"
    
  Scenario: I should be added as an owner to a site I create
    Given I am logged in
      And I go to my account page
    When I follow "Create a site"
      And I fill in "Name" with "Mock Site"
      And I press "Create"
    Then I should see "Successfully created site"
    Then I should be an owner for the site "Mock Site"
  
  Scenario: I should still be the owner of my sites (factory created)
    Given I am logged in
      And I have a site named "site_a"
    Then I should be an owner for the site "site_a"
    

  Scenario: add member to a site
    Given the following users
    | email |
    | joe@example.com |
    Given I am logged in
      And I have a site named "site_a"
    When I go to the memberships page for "site_a"
      And I follow "Add user"
      And I fill in "email" with "joe@example.com"
      And I select "admin" from "membership_role_id"
      And I press "Submit"
    Then I should see "Successfully added user"
      And "site_a" should have user "joe@example.com" with role "admin"
  