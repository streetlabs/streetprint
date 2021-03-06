Feature: User membership with site
  In order allow multiple people to work on a site
  As a site user
  I want to be able to give other users permissions to change my site
  
  Scenario: should not be able to remove owner of site
    Given I am logged in as "user@example.com"
      And I have a site titled "site.a"
    When I go to the edit membership page for "user@example.com" in "site.a"
      And I select "Editor" from "role"
      And I press "Submit"
    Then "site.a" should have user "user@example.com" with role "owner"
    
  Scenario: should be made the owner when creating a site
    Given I am logged in as "user@example.com"
      And I have a site titled "site.a"
    Then "site.a" should have user "user@example.com" with role "owner"
  
  Scenario: should be able to edit a users role
    Given the following users
      |email|
      |joe@example.com|
      
    Given I am logged in
      And I have a site titled "site.a"
      And "site.a" has the user "joe@example.com" with role "admin"
    When I go to the edit membership page for "joe@example.com" in "site.a"
      And I select "Editor" from "role"
      And I press "Submit"
    Then I should see "Successfully updated membership."
      And "site.a" should have user "joe@example.com" with role "editor"

  Scenario: Should give an error if invalid user
    Given I am logged in
      And I have a site titled "site.a"
    When I go to the create membership page for "site.a"
      And I fill in "email" with "unreal_user@example.com"
      And I press "Submit"
    Then I should see each of "error, unreal_user@example.com does not have an account"

  Scenario: Should be able to remove a user
    Given the following users
    |email|
    |joe@example.com|
    Given I am logged in
      And I have a site titled "site.a"
      And "site.a" has the user "joe@example.com"
    When I go to the memberships page for "site.a"
      And I follow remove for the user "joe@example.com"
    Then "site.a" should not have the user "joe@example.com"

    
  Scenario: get error when adding user who already is a member
    Given the following users
    |email|
    |joe@example.com|

    Given I am logged in
      And I have a site titled "site.a"
      And "site.a" has the user "joe@example.com"
    When I go to the create membership page for "site.a"
      And I fill in "email" with "joe@example.com"
      And I press "Submit"
    Then I should see each of "error, already a member"
    
      
  Scenario: add a new member to your site
    Given the following users
    |email|
    |joe@example.com|
    
    Given I am logged in
      And I have a site titled "site.a"
    When I go to the memberships page for "site.a"
      And I follow "Add user"
      And I fill in "email" with "joe@example.com"
      And I select "Admin" from "role"
      And I press "Submit"
    Then I should see "Successfully added user"
      And "site.a" should have user "joe@example.com" with role "admin"
  