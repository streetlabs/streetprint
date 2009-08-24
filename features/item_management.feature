Feature: Manage items
  In order to put my collection on the web
  As a site user
  I want to add/edit/delete items
  
  
  Scenario: Only published items should show up on the public site
    Given "cody" has created the following site
    |title|name|
    |mocksite|Mock Site|
    
    And "mocksite" has the following items
    |title|published|
    |item1|false|
    |item2|true|
    
    When I go to the items page for "mocksite"
    Then I should see "item2"
      And I should not see "item1"
    
    Then the item page for "item1" in "mocksite" should not be found
    
    
  Scenario: publish / unpublish an item from item edit page
    Given "cody" has created the following site
    | title    | name      |
    | mocksite | Mock Site |

    And "mocksite" has the following items
    | title | published |
    | item1 | false     |
    
    And I log in as "cody@streetprint.org"

    When I go to the edit item page for "item1" in "mocksite"
      And I check "published"
      And I press "Submit"
    Then "item1" should be published
    
    When I go to the edit item page for "item1" in "mocksite"
      And I uncheck "published"
      And I press "Submit"
    Then "item1" should not be published
  
  
  Scenario: publish / unpublish an item from item index page
    Given "cody" has created the following site
    | title    | name      |
    | mocksite | Mock Site |

    And "mocksite" has the following items
    | title | published |
    | item1 | false     |
    
    And I log in as "cody@streetprint.org"

    When I go to the admin items page for "mocksite"
      And I press the publish button for "item1"
    Then "item1" should be published
    
    When I go to the admin items page for "mocksite"
      And I press the unpublish button for "item1"
    Then "item1" should not be published
    
        
    Scenario: delete an item
        Given I am logged in
          And I have a site titled "site.a"
          And "site.a" has an item with title "mock item"
          And I am on the admin items page for "site.a"
        Then I should see "mock item"
        
        When I follow "delete"
        Then I should be on the admin subdomain items page for "site.a"
          And I should not see "mock item"
        
    Scenario: update an item
        Given I am logged in
          And I have a site titled "site.a"
          And "site.a" has an item with title "mock item"
        When I go to the edit item page for "mock item" in "site.a"
          And I fill in "title" with "updated item"
          And I press "submit"
        Then I should see "Successfully updated"
        
        When I go to the items page for "site.a"
        Then I should see "updated item"
    
    Scenario: friendly notice when error creating item
      Given I am logged in
        And I have a site titled "site.a"
        And I am on the items page for "site.a"
        And I go to the create item page for "site.a"
        And I press "submit"
      Then I should see "Title can't be blank"
      
    Scenario: friendly notice when error editing item
      Given I am logged in
        And I have a site titled "site.a"
        And "site.a" has an item with title "mock item"
      When I go to the edit item page for "mock item" in "site.a"
        And I fill in "title" with ""
        And I press "submit"
      Then I should see "Title can't be blank"
      
    @thinking_sphinx
    Scenario: should be able to do basic search for an item
      Given I am logged in
        And I have a site titled "site.a"
        And "site.a" has the following items
        | title            |
        | programming ruby |
        | c programming    |
        | java             |
        | symbolic logic   |
      When I go to the items page for "site.a"
      And I fill in "search" with "programming"
      And I press "Search"
      Then I should see each of "programming ruby, c programming"
        And I should not see each of "java, symbolic logic"
        
    Scenario: Items should be 10 to a page
      Given I am logged in
        And I have a site titled "site.a"
        And "site.a" has the following items
        | title   |
        | item_1  |
        | item_2  |
        | item_3  |
        | item_4  |
        | item_5  |
        | item_6  |
        | item_7  | 
        | item_8  |
        | item_9  |
        | item_10 |
        | item_11 |
      When I go to the items page for "site.a"
      Then I should see items "item_1, item_2, item_3, item_4, item_5, item_6, item_7, item_8, item_9, item_10"
        And I should not see item "item_11"
      
      When I follow "Next"
      Then I should see item "item_11"
        And I should not see items "item_1, item_2, item_3, item_4, item_5, item_6, item_7, item_8, item_9, item_10"
  
  Scenario: Create an item with all the necessary fields
    Given I am logged in
      And I have a site titled "site.a"
      And "site.a" has a document type with name "type1"
    When I go to the create item page for "site.a"
      And I check "published"
      And I fill in "title" with "mock title"
      And I fill in "introduction" with "a brief introduction"
      And I fill in "year" with "2000"
      And I select "January" from "date_month"
      And I select "31" from "date_day"
      And I fill in "date details" with "a date"
      And I fill in "location" with "edmonton"
    
      And I fill in "publisher" with "a publisher"
      And I fill in "publisher details" with "details for the publisher"
      And I fill in "printer" with "a printer"
      And I fill in "printer details" with "details for the printer"
      And I fill in "seller" with "a bookseller"
      And I fill in "seller details" with "details for the bookseller"
      And I fill in "binder" with "a bookbinder"
      And I fill in "binder details" with "details for the bookbinder"
    
      And I fill in "price" with "6d"
      And I fill in "pagination" with "200"
      And I check "serialized"
      And I fill in "footnotes" with "notes at the foot"
      And I fill in "endnotes" with "notes at the end"
      And I fill in "index" with "in the dex"
      And I fill in "advertisements" with "some info on advertisements"
    
      And I fill in "binding" with "Quarter calf"
      And I fill in "edges" with "trimmed"
      And I fill in "dimensions" with "5x5x5"
      And I check "foxing"
      And I fill in "illustrations" with "some cool illustrations"
      And I fill in "provenance" with "Book Plate: To Henrietta Walker"
      And I fill in "Marginalia" with "There are pencil marks beside poem titles throughout. "
      And I fill in "summary of contents" with "p. i title page. p. iii contents. p. 5-72 text. p. 73 advertisement."
      And I fill in "notes" with "The book's publication date is not stated within the text."
      And I fill in "references" with "Avery, Gillian. Darton, William (1755–1819). Oxford Dictionary of National"
    
    
      # strictly for backwards compatability
      And I fill in "reference number" with "123"
      And I fill in "city" with "Edmonton"
      And I select "type1" from "item_document_type_id"
      And I fill in "full text" with lorem ipsum
    
      And I press "Submit"
    
    Then I should see "Successfully created"
      And I should see each of "mock title, a brief introduction, 2000, January, 31, a date, edmonton"
      And I should see each of "a publisher, details for the publisher, a printer, details for the printer, a bookseller, details for the bookseller, a bookbinder, details for the bookbinder"
      And I should see each of "6d, 200, notes at the foot, notes at the end, in the dex, some info on advertisements"
      And I should see each of "Quarter calf, trimmed, 5x5x5, some cool illustrations, Book Plate: To Henrietta Walker"
      And I should see "There are pencil marks beside poem titles throughout."
      And I should see "p. i title page. p. iii contents. p. 5-72 text. p. 73 advertisement."
      And I should see "The book's publication date is not stated within the text."
      And I should see "Avery, Gillian. Darton, William (1755–1819). Oxford Dictionary of National"
    
    When I follow "full text"
    Then I should see "Lorem ipsum"
    When I go to the item page for "mock title" in "site.a"
      And I follow "full text"
    Then I should see "Lorem ipsum"
    