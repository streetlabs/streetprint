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
      