Feature: User membership with site
  In order allow multiple people to work on a site
  As a site user
  I want to be able to give other users permissions to change my site
  
  Scenario: I should be added as an owner to a site I create
    Given I am logged in
      And I go to my account page
    When I follow "Create a site"
      And I fill in "Name" with "Mock Site"
      And I press "Create"
    Then I should be an owner for the site "Mock Site"
  
  Scenario: I should still be the owner of my sites (factory created)
    Given I am logged in
      And I have a site named "site_a"
    Then I should be an owner for the site "site_a"
    
    
  Scenario: Should not be able to remove myself (the owner) from a site
    Given I am logged in
      And I have a site named "site_a"
    When I go to the edit site page for "site_a"
    Then there should be no remove link for myself