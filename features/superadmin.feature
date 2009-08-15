Feature: Superadmin
  In order to administer the streetprint site
  As a superadmin
  I want to be able to perform some superadmin tasks though a nice interface
  
  Scenario: superadmin can approve sites
    
    Given the following user
    | email            | active |
    | user@streetprint.org | true   |
    
    Given the following site
    | name      | title    | approved |
    | Mock Site | mocksite | false    |
    
    Given I am logged in as "admin@streetprint.org"
      And "admin@streetprint.org" is a superadmin
      And I go to the sites administration page for "mocksite"
      And I press approve for site "mocksite"
    Then "mocksite" should be approved
  
  
  Scenario: superadmin can remove approvals
  
    Given the following user
    | email            | active |
    | user@streetprint.org | true   |
    
    Given the following site
    | name      | title    | approved |
    | Mock Site | mocksite | true     |
    
    Given I am logged in as "admin@streetprint.org"
      And "admin@streetprint.org" is a superadmin
      And I go to the sites administration page
      And I press disapprove for site "mocksite"
    Then "mocksite" should not be approved