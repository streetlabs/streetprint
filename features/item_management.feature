Feature: Manage items
    In order to put my collection on the web
    As a site user
    I want to add/edit/delete items
    
    
    
    
    Scenario: Items should have the necessary fields
      Given I am logged in
        And I have a site named "site_a"
        And "site_a" has a document type with name "type1"
      When I go to the create item page for "site_a"
        And I fill in "title" with "mock title"
        And I fill in "introduction" with "a brief introduction"
        And I fill in "item_date_string" with "2009/01/08"
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
        
      Then I should see "Successfully created item"
        And I should see each of "mock title, a brief introduction, 2009/01/08, a date, edmonton"
        And I should see each of "a publisher, details for the publisher, a printer, details for the printer, a bookseller, details for the bookseller, a bookbinder, details for the bookbinder"
        And I should see each of "6d, 200, notes at the foot, notes at the end, in the dex, some info on advertisements"
        And I should see each of "Quarter calf, trimmed, 5x5x5, some cool illustrations, Book Plate: To Henrietta Walker"
        And I should see "There are pencil marks beside poem titles throughout."
        And I should see "p. i title page. p. iii contents. p. 5-72 text. p. 73 advertisement."
        And I should see "The book's publication date is not stated within the text."
        And I should see "Avery, Gillian. Darton, William (1755–1819). Oxford Dictionary of National"
        
      When I follow "full text"
      Then I should see "Lorem ipsum"
    
    Scenario: create an item
        Given I am logged in
          And I have a site named "site_a"
          And I am on the items page for "site_a"
        When I follow "New Item"
          And I fill in "title" with "mock item"
          And I press "submit"
          And I go to the items page for "site_a"
        Then I should see "mock item"
        
    Scenario: delete an item
        Given I am logged in
          And I have a site named "site_a"
          And "site_a" has an item with title "mock item"
          And I am on the items page for "site_a"
        Then I should see "mock item"
        
        When I follow "destroy"
        Then I should be on the items page for "site_a"
          And I should not see "mock item"
        
    Scenario: update an item
        Given I am logged in
          And I have a site named "site_a"
          And "site_a" has an item with title "mock item"
        When I go to the item page for "mock item" in "site_a"
          And I follow "edit"
          And I fill in "title" with "updated item"
          And I press "submit"
        Then I should see "Successfully updated item."
        
        When I go to the items page for "site_a"
        Then I should see "updated item"
    
    Scenario: friendly notice when error creating item
      Given I am logged in
        And I have a site named "site_a"
        And I am on the items page for "site_a"
      When I follow "New Item"
        And I press "submit"
      Then I should see "Title can't be blank"
      
    Scenario: friendly notice when error editing item
      Given I am logged in
        And I have a site named "site_a"
        And "site_a" has an item with title "mock item"
      When I go to the item page for "mock item" in "site_a"
        And I follow "edit"
        And I fill in "title" with ""
        And I press "submit"
      Then I should see "Title can't be blank"
      
    @thinking_sphinx
    Scenario: should be able to do basic search for an item
      Given I am logged in
        And I have a site named "site_a"
        And "site_a" has the following items
        | title            |
        | programming ruby |
        | c programming    |
        | java             |
        | symbolic logic   |
      When I go to the items page for "site_a"
      And I fill in "search" with "programming"
      And I press "Search"
      Then I should see each of "programming ruby, c programming"
        And I should not see each of "java, symbolic logic"
        
    Scenario: Items should be 10 to a page
      Given I am logged in
        And I have a site named "site_a"
        And "site_a" has the following items
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
      When I go to the items page for "site_a"
      Then I should see each of "1, 2, 3, 4, 5, 6, 7, 8, 9, 10"
        And I should not see "11"
      
      When I follow "Next"
      Then I should see "11"
        And I should not see each of "1, 2, 3, 4, 5, 6, 7, 8, 9, 10"
      
  Scenario: date validation
    Given I am logged in
      And I have a site named "site_a"
    When I go to the create item page for "site_a"
      And I fill in "title" with "mock item"
      And I fill in "item_date_string" with "200"
      And I press "Submit"
    Then I should see each of "error, Date is invalid. Check format."
    
    When I fill in "item_date_string" with "19999/01/01"
      And I press "Submit"
    Then I should see each of "error, Date is invalid. Check format."
    