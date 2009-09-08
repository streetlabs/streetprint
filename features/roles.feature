Feature: Role based permissions
  In order to allow users to work on my site without destroying it
  As a site owner
  I want to be able to give others permissions to perform certain tasks
  
  
  Background:
    Given the following users
    | email                      | active |
    | admin@example.com          | true   |
    | editor@example.com         | true   |
    | superadmin@streetprint.org | true   |
  
    Given I am logged in as "owner@example.com"
      And I have a site titled "mocksite"
      And I have the following themes
      | name       | user |
      | mock theme | admin@example.com |
      | default theme | |
      And "mocksite" has the user "admin@example.com" with role "admin"
      And "mocksite" has the user "editor@example.com" with role "editor"
      And "mocksite" has the following authors
      |name|
      |author_a|
      |author_b|
      And "mocksite" has the following categories
      |name|
      |cat_a|
      |cat_b|
      And "mocksite" has the following document types
      |name|
      |dt_a|
      |dt_b|
      And "mocksite" has the following news posts
      |title|content|
      |post_a|some news|
      And "mocksite" has the following items
| title | reference_number | year | month | day | date_details | dimensions | pagination | illustrations | location | notes | publisher | city | document_type | categories | authors |
| item_1 | 0001 | 2009 | 01 | 01 |  |  |  |  | location_f |  | publisher_a | city_a | dt_b | cat_a, cat_b | author_a, author_b |
| item_2 | 0002 | 2009 | 01 | 05 |  |  |  |  | location_g |  | publisher_a | city_a | dt_b | cat_a, cat_b | author_a, author_b |
| item_3 | 0003 | 2009 | 02 | 01 |  |  |  |  | location_h |  | publisher_a | city_a | dt_b | cat_a, cat_b | author_a, author_b |
| item_4 | 0004 | 2008 | 01 | 01 |  |  |  |  | location_i |  | publisher_a | city_a | dt_b | cat_a | author_a           |
     And I am on the site page for "mocksite"
     And I log out


  Scenario: Owners, Admins, Editors, and Anonymous users have the correct privileges
    Given I am logged out
    Then I should have access to the homepage
      And I should have access to the registration page
      And I should have access to the login page
      And I should have access to the forgot password page
      And I should be denied access to the my account page
      And I should be denied access to the admin page
      # site
      And I should be denied access to the sites page
      And I should have access to the site page for "mocksite"
      And I should be denied access to the create site page
      And I should be denied access to the edit site page for "mocksite"
      # items
      And I should have access to the items page for "mocksite"
      And I should have access to the item page for "item_1" in "mocksite"
      And I should be denied access to the create item page for "mocksite"
      And I should be denied access to the edit item page for "item_1" in "mocksite"
      # authors
      And I should be denied access to the authors page for "mocksite"
      And I should have access to the author page for "author_a" in "mocksite"
      And I should be denied access to the create authors page for "mocksite"
      And I should be denied access to the edit author page for "author_a" in "mocksite"
      # categories
      And I should be denied access to the categories page for "mocksite"
      And I should be denied access to the category page for "cat_a" in "mocksite"
      And I should be denied access to the create category page for "mocksite"
      And I should be denied access to the edit category page for "cat_a" in "mocksite"
      # document types
      And I should be denied access to the document types page for "mocksite"
      And I should be denied access to the document type page for "dt_a" in "mocksite"
      And I should be denied access to the create document type page for "mocksite"
      And I should be denied access to the edit document type page for "dt_a" in "mocksite"
      # memberships
      And I should be denied access to the memberships page for "mocksite"
      And I should be denied access to the create membership page for "mocksite"
      And I should be denied access to the edit membership page for "admin@example.com" in "mocksite"
      # news posts
      And I should have access to the news page for "mocksite"
      And I should be denied access to the create news page for "mocksite"
      And I should be denied access to the edit news page for "post_a" in "mocksite"
      
      And I should have access to the browse page for "mocksite"
      And I should have access to the about page for site "mocksite"
      And I should be denied access to the edit site theme page for "mocksite"
      
      And I should be denied access to the themes page
      And I should be denied access to the new theme page
      And I should be denied access to the edit theme page for "mock theme"
      And I should be denied access to the edit theme page for "default theme"
      
      # superadmin pages
      And I should be denied access to the sites administration page
      
    
    When I log in as "editor@example.com"
    Then I should have access to the homepage
      And I should be denied access to the registration page
      And I should have access to the login page
      And I should be denied access to the forgot password page
      And I should have access to the my account page
      And I should have access to the admin page
      # site
      And I should have access to the sites page
      And I should have access to the site page for "mocksite"
      And I should have access to the create site page
      And I should be denied access to the edit site page for "mocksite"
      # items
      And I should have access to the items page for "mocksite"
      And I should have access to the item page for "item_1" in "mocksite"
      And I should have access to the create item page for "mocksite"
      And I should have access to the edit item page for "item_1" in "mocksite"
      # authors
      And I should have access to the authors page for "mocksite"
      And I should have access to the author page for "author_a" in "mocksite"
      And I should have access to the create authors page for "mocksite"
      And I should have access to the edit author page for "author_a" in "mocksite"
      # categories
      And I should have access to the categories page for "mocksite"
      And I should have access to the category page for "cat_a" in "mocksite"
      And I should have access to the create category page for "mocksite"
      And I should have access to the edit category page for "cat_a" in "mocksite"
      # document types
      And I should have access to the document types page for "mocksite"
      And I should have access to the document type page for "dt_a" in "mocksite"
      And I should have access to the create document type page for "mocksite"
      And I should have access to the edit document type page for "dt_a" in "mocksite"
      # memberships
      And I should be denied access to the memberships page for "mocksite"
      And I should be denied access to the create membership page for "mocksite"
      And I should be denied access to the edit membership page for "admin@example.com" in "mocksite"
      # news posts
      And I should have access to the news page for "mocksite"
      And I should have access to the create news page for "mocksite"
      And I should have access to the edit news page for "post_a" in "mocksite"

      And I should have access to the browse page for "mocksite"
      And I should have access to the about page for site "mocksite"
      And I should be denied access to the edit site theme page for "mocksite"
      
      And I should have access to the themes page
      And I should have access to the new theme page
      And I should be denied access to the edit theme page for "mock theme"
      And I should be denied access to the edit theme page for "default theme"
      
      # superadmin pages
      And I should be denied access to the sites administration page
      
    
    When I log in as "admin@example.com"
    Then I should have access to the homepage
      And I should be denied access to the registration page
      And I should have access to the login page
      And I should be denied access to the forgot password page
      And I should have access to the my account page
      And I should have access to the admin page
      # site
      And I should have access to the sites page
      And I should have access to the site page for "mocksite"
      And I should have access to the create site page
      And I should have access to the edit site page for "mocksite"
      # items
      And I should have access to the items page for "mocksite"
      And I should have access to the item page for "item_1" in "mocksite"
      And I should have access to the create item page for "mocksite"
      And I should have access to the edit item page for "item_1" in "mocksite"
      # authors
      And I should have access to the authors page for "mocksite"
      And I should have access to the author page for "author_a" in "mocksite"
      And I should have access to the create authors page for "mocksite"
      And I should have access to the edit author page for "author_a" in "mocksite"
      # categories
      And I should have access to the categories page for "mocksite"
      And I should have access to the category page for "cat_a" in "mocksite"
      And I should have access to the create category page for "mocksite"
      And I should have access to the edit category page for "cat_a" in "mocksite"
      # document types
      And I should have access to the document types page for "mocksite"
      And I should have access to the document type page for "dt_a" in "mocksite"
      And I should have access to the create document type page for "mocksite"
      And I should have access to the edit document type page for "dt_a" in "mocksite"
      # memberships
      And I should have access to the memberships page for "mocksite"
      And I should have access to the create membership page for "mocksite"
      And I should have access to the edit membership page for "admin@example.com" in "mocksite"
      # news posts
      And I should have access to the news page for "mocksite"
      And I should have access to the create news page for "mocksite"
      And I should have access to the edit news page for "post_a" in "mocksite"

      And I should have access to the browse page for "mocksite"
      And I should have access to the about page for site "mocksite"
      And I should have access to the edit site theme page for "mocksite"
      
      And I should have access to the themes page
      And I should have access to the new theme page
      And I should have access to the edit theme page for "mock theme"
      And I should be denied access to the edit theme page for "default theme"
      
      # superadmin pages
      And I should be denied access to the sites administration page
      
      
    When I log in as "owner@example.com"
    Then I should have access to the homepage
      And I should be denied access to the registration page
      And I should have access to the login page
      And I should be denied access to the forgot password page
      And I should have access to the my account page
      And I should have access to the admin page
      # site
      And I should have access to the sites page
      And I should have access to the site page for "mocksite"
      And I should have access to the create site page
      And I should have access to the edit site page for "mocksite"
      # items
      And I should have access to the items page for "mocksite"
      And I should have access to the item page for "item_1" in "mocksite"
      And I should have access to the create item page for "mocksite"
      And I should have access to the edit item page for "item_1" in "mocksite"
      # authors
      And I should have access to the authors page for "mocksite"
      And I should have access to the author page for "author_a" in "mocksite"
      And I should have access to the create authors page for "mocksite"
      And I should have access to the edit author page for "author_a" in "mocksite"
      # categories
      And I should have access to the categories page for "mocksite"
      And I should have access to the category page for "cat_a" in "mocksite"
      And I should have access to the create category page for "mocksite"
      And I should have access to the edit category page for "cat_a" in "mocksite"
      # document types
      And I should have access to the document types page for "mocksite"
      And I should have access to the document type page for "dt_a" in "mocksite"
      And I should have access to the create document type page for "mocksite"
      And I should have access to the edit document type page for "dt_a" in "mocksite"
      # memberships
      And I should have access to the memberships page for "mocksite"
      And I should have access to the create membership page for "mocksite"
      And I should have access to the edit membership page for "admin@example.com" in "mocksite"
      # news posts
      And I should have access to the news page for "mocksite"
      And I should have access to the create news page for "mocksite"
      And I should have access to the edit news page for "post_a" in "mocksite"

      And I should have access to the browse page for "mocksite"
      And I should have access to the about page for site "mocksite"
      And I should have access to the edit site theme page for "mocksite"
      
      And I should have access to the themes page
      And I should have access to the new theme page
      And I should be denied access to the edit theme page for "mock theme"
      And I should be denied access to the edit theme page for "default theme"
      
      # superadmin pages
      And I should be denied access to the sites administration page
      
      
  Scenario: superadmins have access to everything
    Given I log in as "superadmin@streetprint.org"
      And "superadmin@streetprint.org" is a superadmin
    Then I should have access to the sites administration page  
      And I should have access to the edit theme page for "default theme"
  
  
  
      