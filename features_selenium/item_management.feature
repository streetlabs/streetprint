Feature: Manage items
  Scenario: create an item with multiple categories
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has the following categories
      | name  | description     |
      | cat_a | mock category   |
      | cat_b | mock category b |
      
    When I go to the create item page for "site_a"
      And I fill in "title" with "mock item"
      And I follow "Add category"
      And I select "cat_a" from the "first" category dropdown
      And I follow "Add category"
      And I select "cat_b" from the "second" category dropdown
      And I press "Submit" and wait for the page to load
    Then I should see "Successfully created item."
      And I should see each of "cat_a, cat_b"
    
  Scenario: create an item with a category
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has the following categories
      | name  | description   |
      | cat_a | mock category |

    When I go to the create item page for "site_a"
      And I follow "Add category"
      And I fill in "title" with "category test"
      And I select "cat_a" from "new_category_select"
      And I press "Submit" and wait for the page to load
    Then I should see "Successfully created item."
      And I should see "cat_a"

  Scenario: remove a category from an item
    Given I am logged in
      And I have site named "site_a"
      And "site_a" has the following categories
      | name  | description   |
      | cat_a | mock category |
    
      And "site_a" has the following items
      | title     | categories |
      | mock item | cat_a      |

    When I go to the edit item page for "mock item" in "site_a"
      And I click remove for the first category
      And I press "Submit" and wait for the page to load
    Then I should see "Successfully updated item"
      And I should not see "cat_a"
    
  Scenario: create an item with multiple authors
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has an author with name "john"
      And "site_a" has an author with name "sue"
    When I go to the create item page for "site_a"
      And I fill in "title" with "mock item"
      And I follow "Add author"
      And I select "john" from the "first" author dropdown
      And I follow "Add author"
      And I select "sue" from the "second" author dropdown
      And I press "Submit" and wait for the page to load
    Then I should see "Successfully created item."
      And I should see each of "john, sue"
      

  Scenario: remove an author from an item
    Given I am logged in
      And I have site named "site_a"
      And "site_a" has an author with name "john"
      And "site_a" has an item with title "mock item" and author "john"
    When I go to the edit item page for "mock item" in "site_a"
      And I click remove for the first author
      And I press "Submit" and wait for the page to load
    Then I should see "Successfully updated item"
      And I should not see "john"

  Scenario: create an item with an author
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has an author with name "john"
    When I go to the create item page for "site_a"
      And I follow "Add author"
      And I fill in "title" with "author test"
      And I select "john" from "new_author_select"
      And I press "Submit" and wait for the page to load
    Then I should see "Successfully created item."
      And I should see "john"

  Scenario: add a photo to an item
    Given I am logged in
      And I have a site named "site_a"
      And "site_a" has an item with title "mock item"
    When I go to the item page for "mock item" in "site_a"
      And I follow "Edit"
      And I fill in "item_photo_attributes__photo" with the file "features/test_images/rails.png"
      And I press "Submit" and wait for the page to load
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
      And I remove the first photo
      And I press "Submit" and wait for the page to load
    Then the item should have 2 photos
      And the files generated for the photo should not exist
      
      