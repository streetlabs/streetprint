Feature: Site Permissions
  In order to keep my information private
  As a site owner
  I want to keep others from seeing my information
  

  
  
  
  # accounts
  Scenario: The account page should not be accessible when logged out
    Given I have an account with email "user@example.com"
    Then I should be denied access to my account page


  # sites
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
      
  Scenario: The site pages should not be accessible when logged out
    Then I should be denied access to the sites page
    
  Scenario: Should not be able to edit others sites
    Given I am logged in as "user@example.com"
      And I have a site named "site_a"
      And I log out

    Given I am logged in as "other_user@example.com"
    When I go to the site page for "site_a"
    Then I should not see "Edit"
      And I should be denied access to the edit site page for "site_a"
    
  Scenario: Should not see edit links for site/items if not logged in as the site owner
    Given I am logged in as "user@example.com"
      And I have a site named "site_a"
      And "site_a" has an item with title "mock item"
      And I log out

    Given I am logged in as "other_user@example.com"
    When I go to the site page for "site_a"
    Then I should not see "Edit this site"
      And I should not see "Edit this item"

    
  # authors
  Scenario: Author show pages accessible when logged out
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has an author with name "john"
      And I log out
    When I go to the author page for "john" in "site_a"
    Then I should be on the author page for "john" in "site_a"
      And I should see "john"
      And I should not see "Edit"
  
  Scenario: Should not be able to edit others authors
    Given I am logged in as "user@example.com"
      And I have a site named "site_a"
      And "site_a" has an author with name "john"
      And I log out
    
    Given I am logged in as "other_user@example.com"
    When I go to the author page for "john" in "site_a"
    Then I should not see "Edit"
    
    Then I should be denied access to the edit author page for "john" in "site_a"
    
    
  # document types
  Scenario: Document type pages require site owner
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has the following document types
      | name   |
      | type_a |
      And I log out
    Then I should be denied access to the document type page for "type_a" in "site_a"
    
    Given I am logged in as "other_user@example.com"
    Then I should be denied access to the document type page for "type_a" in "site_a"
      
  # news posts
  Scenario: Should not see admin links for news posts
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has the following news posts
      | title  | content        |
      | news_a | news_a content |
      | news_b | news_b content |
      And I log out
    When I go to the news page for "site_a"
    Then I should not see "Create new post"
      And I should not see "Edit"

  Scenario: Should not be able to edit news posts
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has the following news posts
      | title  | content        |
      | news_a | news_a content |
      | news_b | news_b content |
      And I log out
    Then I should be denied access to the new news page for "site_a"
      And I should be denied access to the edit news page for "news_a" in "site_a"
