Feature: Manage items

  Scenario: add a photo to an item
    Given I am logged in
      And there is an item with title "mock item"
    When I visit the item page for the item
      And I follow "Edit"
      And I fill in "item_photo_attributes__photo" with the file "features/test_images/rails.png"
      And I press "Submit"
    Then I should see "Successfully updated item."
      And the item should have 1 photo
      And the correct sized photos should have been created from the photo
      