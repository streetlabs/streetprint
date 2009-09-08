Feature: Breadcrumb trail
  In order to flow through the site better
  As any one who browses though a site created on streetprint
  I want to have a breadcrumb trail showing where I have come from.
  
  Background:
  Given the following users
  | email                  | active |
  | member@streetprint.org | true   |

    Given I am logged in as "cody@streetprint.org"
      And I have a site titled "mocksite"
      And I have the following themes
      | name       | user |
      | Mock Theme | cody@streetprint.org |
      And "mocksite" has the user "member@streetprint.org"
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
      | title  | content   |
      | post_a | content_a |
      And "mocksite" has the following items
 | title | reference_number | date_details | dimensions | pagination | illustrations | location | notes | publisher | city | document_type | categories | authors |
 | item_1 | 0001 |  |  |  |  | location_f |  | publisher_a | city_a | dt_b | cat_a, cat_b | author_a, author_b |
 | item_2 | 0002 |  |  |  |  | location_g |  | publisher_a | city_a | dt_b | cat_a, cat_b | author_a, author_b |
 | item_3 | 0003 |  |  |  |  | location_h |  | publisher_a | city_a | dt_b | cat_a, cat_b | author_a, author_b |
 | item_4 | 0004 |  |  |  |  | location_i |  | publisher_a | city_a | dt_b | cat_a | author_a           |
 | item_5 | 0005 |  |  |  |  | location_a |  | publisher_b | city_b | dt_b | cat_a | author_a           |
 | item_6 | 0006 |  |  |  |  | location_b |  | publisher_b | city_b | dt_a | cat_a | author_a           |
 | item_7 | 0007 |  |  |  |  | location_c |  | publisher_b | city_b | dt_a | cat_b | author_b           |
 | item_8 | 0008 |  |  |  |  | location_d |  | publisher_b | city_b | dt_a | cat_b | author_b           |
 | item_9 | 0009 |  |  |  |  | location_e |  | publisher_b | city_c | dt_a | cat_b | author_b           |
  
  
  
  Scenario: Appropriate breadcrumb on appropriate visitor pages
    Given I am on the site page for "mocksite"
    Then the breadcrumb should be empty
    
    Given I am on the author page for "author_a" in "mocksite"
    Then the breadcrumb should contain "Home, Author, author_a"
    
    Given I am on the news page for "mocksite"
    Then the breadcrumb should contain "Home, News"
    
    Given I am on the about page for site "mocksite"
    Then the breadcrumb should contain "Home, About"
    
    Given I am on the browse page for "mocksite"
    Then the breadcrumb should contain "Home, Browse"
    When I follow "Category"
    Then the breadcrumb should contain "Home, Browse, Category"
    When I follow "cat_a"
    Then the breadcrumb should contain "Home, Search"
    
    Given I am on the item page for "item_1" in "mocksite"
    Then the breadcrumb should contain "Home, Search, item_1"
    
  
  Scenario: Appropriate breadcrumb on appropriate user pages
    Given I am on the admin page
    Then the breadcrumb should be empty
    
    Given I am on the authors page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Authors"
    Given I am on the admin author page for "author_a" in "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Authors, author_a"
    Given I am on the edit author page for "author_a" in "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Authors, Edit author"
    Given I am on the create authors page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Authors, New author"
    
    Given I am on the categories page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Categories"
    Given I am on the category page for "cat_a" in "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Categories, cat_a"
    Given I am on the edit category page for "cat_a" in "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Categories, Edit category"
    Given I am on the create category page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Categories, New category"
    
    Given I am on the document types page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Document types"
    Given I am on the document type page for "dt_a" in "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Document types, dt_a"
    Given I am on the edit document type page for "dt_a" in "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Document types, Edit document type"
    Given I am on the create document type page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Document types, New document type"

    Given I am on the admin items page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Search"
    Given I am on the admin item page for "item_1" in "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Categories, item_1"
    Given I am on the edit item page for "item_1" in "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Search, Edit item"
    Given I am on the create item page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Search, New item"
    
    Given I am on the memberships page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Contributers"
    Given I am on the edit membership page for "member@streetprint.org" in "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Contributers, Edit contributer"
    Given I am on the create membership page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, Contributers, New contributer"
    
    Given I am on the admin news page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, News"
    Given I am on the edit news page for "post_a" in "mocksite"
    Then the breadcrumb should contain "Home, mocksite, News, Edit post"
    Given I am on the create news page for "mocksite"
    Then the breadcrumb should contain "Home, mocksite, News, New post"
    
    Given I am on the themes page
    Then the breadcrumb should contain "Home, Themes"
    Given I am on the new theme page
    Then the breadcrumb should contain "Home, Themes, New"
    Given I am on the edit theme page for "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, Edit"
    
    Given I am on the edit template page for "Browse" in "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, Browse artifacts page"
    
    Given I am on the edit template page for "Search" in "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, Search artifacts page"
    
    Given I am on the edit template page for "Layout" in "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, Layout"
    
    Given I am on the edit template page for "About" in "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, About page"
    
    Given I am on the edit template page for "Show Artifact" in "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, Show artifacts page"
    
    Given I am on the edit template page for "Show Author" in "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, Show author"
    
    Given I am on the edit template page for "Show Full Text" in "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, Full text page"
    
    Given I am on the edit template page for "Show Google Location" in "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, Google location page"
    
    Given I am on the edit template page for "Show News" in "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, News page"
    
    Given I am on the edit template page for "Show Site" in "Mock Theme"
    Then the breadcrumb should contain "Home, Themes, Mock Theme, Home page"
    
    