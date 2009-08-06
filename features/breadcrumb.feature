Feature: Breadcrumb trail
  In order to flow through the site better
  As any one who browses though a site created on streetprint
  I want to have a breadcrumb trail showing where I have come from.
  
  Background:
    Given I am logged in
      And I have a site named "mock site"
      And "mock site" has the following authors
      |name|
      |author_a|
      |author_b|
      And "mock site" has the following categories
      |name|
      |cat_a|
      |cat_b|
      And "mock site" has the following document types
      |name|
      |dt_a|
      |dt_b|
      And "mock site" has the following items
 | title | reference_number | date_string | date_details | dimensions | pagination | illustrations | location | notes | publisher | city | document_type | categories | authors |
 | item_1 | 0001 | 2009/01/01 |  |  |  |  | location_f |  | publisher_a | city_a | dt_b | cat_a, cat_b | author_a, author_b |
 | item_2 | 0002 | 2009/01/05 |  |  |  |  | location_g |  | publisher_a | city_a | dt_b | cat_a, cat_b | author_a, author_b |
 | item_3 | 0003 | 2009/02/01 |  |  |  |  | location_h |  | publisher_a | city_a | dt_b | cat_a, cat_b | author_a, author_b |
 | item_4 | 0004 | 2008/01/01 |  |  |  |  | location_i |  | publisher_a | city_a | dt_b | cat_a | author_a           |
 | item_5 | 0005 | 2008/10/20 |  |  |  |  | location_a |  | publisher_b | city_b | dt_b | cat_a | author_a           |
 | item_6 | 0006 | 2008/12/25 |  |  |  |  | location_b |  | publisher_b | city_b | dt_a | cat_a | author_a           |
 | item_7 | 0007 | 2007/01/08 |  |  |  |  | location_c |  | publisher_b | city_b | dt_a | cat_b | author_b           |
 | item_8 | 0008 | 2007/02/14 |  |  |  |  | location_d |  | publisher_b | city_b | dt_a | cat_b | author_b           |
 | item_9 | 0009 | 2007/10/31 |  |  |  |  | location_e |  | publisher_b | city_c | dt_a | cat_b | author_b           |
  
  
  
  Scenario: Appropriate breadcrumb on appropriate pages
    Given I am on the site page for "mock site"
    Then the breadcrumb should be empty
    
    Given I am on the author page for "author_a" in "mock site"
    Then the breadcrumb should contain "Home, Author, author_a"
    
    Given I am on the news page for "mock site"
    Then the breadcrumb should contain "Home, News"
    
    Given I am on the about page for site "mock site"
    Then the breadcrumb should contain "Home, About"
    
    Given I am on the browse page for "mock site"
    Then the breadcrumb should contain "Home, Browse"
    When I follow "Category"
    Then the breadcrumb should contain "Home, Browse, Category"
    When I follow "cat_a"
    Then the breadcrumb should contain "Home, Search"
    
    Given I am on the item page for "item_1" in "mock site"
    Then the breadcrumb should contain "Home, Search, item_1"
    
    
