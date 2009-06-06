Feature: Manage items
    In order to put my collection on the web
    As a site user
    I want to add/edit/delete items
    
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
        
    