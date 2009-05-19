Feature: Manage items
    In order to put my collection on the web
    As a site user
    I want to add/edit/delete items
    
    Scenario: create an item
        Given I am logged in
        And I am on the items page
        When I follow "New Item"
        And I fill in "title" with "mock item"
        And I press "submit"
        And I go to the items page
        Then I should see "mock item"
        
    Scenario: delete an item
        Given I am logged in
        And there is an item with title "mock item"
        And I am on the items page
        Then I should see "mock item"
        
        When I follow "destroy"
        Then I should be on the items page
        Then I should not see "mock item"
        
    Scenario: update an item
        Given I am logged in
        And there is an item with title "mock item"
        When I visit the item page for "mock item"
        And I follow "edit"
        And I fill in "title" with "updated item"
        And I press "submit"
        Then I should see "Successfully updated item."
        
        When I go to the items page
        Then I should see "updated item"
