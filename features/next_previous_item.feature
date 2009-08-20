Feature: next/previous item links on item show page

  Background:
    Given the following users
    |email|active|
    |admin@example.com|true|
    |editor@example.com|true|
  
    Given I am logged in as "owner@example.com"
      And I have a site titled "mocksite"
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

  Scenario: Next previous item links show up and work appropriately
    Given I log in as "owner@example.com"
    When I go to the item page for "item_1" in "mocksite"
    Then there should be a next item link
      And there should not be a previous item link
    
    When I follow "Next Item"
    Then I should be on the subdomain item page for "item_2" in "mocksite"
      And there should be a next item link
      And there should be a previous item link
      
    When I follow "Previous Item"
    Then I should be on the subdomain item page for "item_1" in "mocksite"
    
  
  Scenario: Next previous item links maintain context of search
    When I go to the items page for "mocksite"
      And I fill in "search" with "cat_b"
      And I press "search"
      And I follow "item_1"
    Then there should be a next item link
      And there should not be a previous item link
    
    When I follow "Next Item"
    Then I should be on the subdomain item page for "item_2" in "mocksite"
    
    When I follow "Next Item"
    Then I should be on the subdomain item page for "item_3" in "mocksite"
      And there should not be a next item link