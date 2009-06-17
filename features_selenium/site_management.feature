Feature: Manage sites

  Scenario: create a site with several users
    Given the following users
    | email           |
    | joe@example.com |
    | sue@example.com |
    | bob@example.com |
    | eve@example.com |
    
    Given I am logged in
    When I go to the create site page
      And I fill in "name" with "mock site"
      And I follow "Add user"
      And I fill in the first user field with "joe@example.com"
      And I follow "Add user"
      And I fill in the second user field with "sue@example.com"
      And I follow "Add user"
      And I fill in the third user field with "bob@example.com"
      And I press "Create"
    Then I should see "Successfully created site"
    And I should be on my account page
      
      
  Scenario: remove user from a site
    Given the following users
    | email           |
    | joe@example.com |
    | sue@example.com |

    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has the users "joe@example.com, sue@example.com"
    When I go to the edit site page for "site_a"
      And I click the remove user link for "joe@example.com"
      And I press "Update"
    Then "site_a" should have users "joe@example.com"
    
  Scenario: should get error when user doesn't exist
    Given I am logged in
    When I go to the create site page
      And I follow "Add user"
      And I fill in the first user field with "non_existent_user@example.com"
      And I press "Create"
    Then I should see each of "error, user with email 'non_existent_user@example.com' does not exist"
    
      