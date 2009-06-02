Feature: Manage items

  Scenario: add a photo to an item
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has an item with title "mock item"
    When I go to the item page for "mock item" in "site_a"
      And I follow "Edit"
      And I fill in "item_photo_attributes__photo" with the file "features/test_images/rails.png"
      And I press "Submit"
    Then I should see "Successfully updated item."
      And the item should have 1 photo
      And the correct sized photos should have been created from the photo
      
  Scenario: deleting an item should delete all associated photos
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has an item with title "mock item"
      And the item has 3 photos
    When I delete the item
    Then the photos should not exist
      And the files generated for those photos should not exist
      
  Scenario: delete a photo from an item
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has an item with title "mock item"
      And the item has 3 photos
    When I go to the edit item page for "mock item" in "site_a"
      And I check the box for the first photo
      And I press "Submit" and wait for the page to load
    Then the item should have 2 photos
      And the files generated for the photo should not exist