Feature: Browse
  In order to efficiently look through the items for a site
  As a someone curious about the material but not looking for a specific item
  I want to be able to browse through the items based on certain attributes
  
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
 | title | reference_number | date_string | date_details | dimensions | pagination | illustrations | location | notes | publisher | city | document_type | category | authors |
 | item_1 | 0001 | 2009/01/01 |  |  |  |  | location_f |  | publisher_a | city_a | dt_b | cat_a | author_a, author_b |
 | item_2 | 0002 | 2009/01/01 |  |  |  |  | location_g |  | publisher_a | city_a | dt_b | cat_a | author_a, author_b |
 | item_3 | 0003 | 2009/01/01 |  |  |  |  | location_h |  | publisher_a | city_a | dt_b | cat_a | author_a, author_b |
 | item_4 | 0004 | 2009/01/01 |  |  |  |  | location_i |  | publisher_a | city_a | dt_b | cat_a | author_a           |
 | item_5 | 0005 | 2009/01/01 |  |  |  |  | location_a |  | publisher_b | city_b | dt_b | cat_a | author_a           |
 | item_6 | 0006 | 2009/01/01 |  |  |  |  | location_b |  | publisher_b | city_b | dt_a | cat_b | author_a           |
 | item_7 | 0007 | 2009/01/01 |  |  |  |  | location_c |  | publisher_b | city_b | dt_a | cat_b | author_b           |
 | item_8 | 0008 | 2009/01/01 |  |  |  |  | location_d |  | publisher_b | city_b | dt_a | cat_b | author_b           |
 | item_9 | 0009 | 2009/01/01 |  |  |  |  | location_e |  | publisher_b | city_c | dt_a | cat_b | author_b           |
   And I am on the site page for "mock site"


  Scenario: Browse by title
    When I follow "browse"
      And I follow "Title"

  Scenario: Browse by author
    When I follow "browse"
      And I follow "Author"
      And I follow "author_a"

  Scenario: Browse by category
    When I follow "browse"
      And I follow "Category"
      And I follow "cat_a"

  Scenario: Browse by document type
    When I follow "browse"
      And I follow "Document Type"
      And I follow "dt_a"

  Scenario: Browse by date
    When I follow "browse"
      And I follow "Date"

  Scenario: Browse by publisher
    When I follow "browse"
      And I follow "Publisher"
      And I follow "publisher_a"

  Scenario: Browse by city
    When I follow "browse"
      And I follow "City"
      And I follow "city_a"

  Scenario: Browse by reference number
    When I follow "browse"
      And I follow "Reference Number"

  Scenario: Browse by location
    When I follow "browse"
      And I follow "Location"

  Scenario: Browse by Most recent
    When I follow "browse"
      And I follow "Most Recent"

  Scenario: Browse without parameters
    When I go to the browse page for "mock site"
    