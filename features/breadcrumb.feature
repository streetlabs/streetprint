Feature: Breadcrumb trail
  In order to flow through the site better
  As any one who browses though a site created on streetprint
  I want to have a breadcrumb trail showing where I have come from.
  
  Background:
    Given I am logged in
      And I have a site titled "mocksite"
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
  
  
  
  Scenario: Appropriate breadcrumb on appropriate pages
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
    
    
