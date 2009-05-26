Feature: 
        

    Scenario: add a photo to an item
        Given I am logged in
        
        Given there is an item with title "mock item"
        When I visit the item page for "mock item"
        And I follow "Edit"
        Then I should see "Edit Item"
        And I type "test_photo" into "item_photo_attributes__photo"
        And I press "Submit"
        Then I should see "Successfully updated item."
        
        