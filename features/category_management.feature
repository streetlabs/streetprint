Feature: Manage my categories
    In order categorize my items
    As a site user
    I want create/update categories and tag my items to them
    
    Scenario: should only get category option when there is at least one category
      Given I am logged in
        And I have a site named "site_a"
      When I go to the create item page for "site_a"
      Then I should not see "Category"

    Scenario: friendly notice when error editing category
      Given I am logged in
        And I have a site named "site_a"
        And "site_a" has the following categories
        | name     |
        | category_a |
      When I go to the edit category page for "category_a" in "site_a"
        And I fill in "name" with ""
        And I press "Submit"
      Then I should see "Name can't be blank"

    Scenario: friendly notice when error creating category
      Given I am logged in
        And I have a site named "site_a"
        And I am on the categories page for "site_a"
      When I follow "New Category"
        And I press "submit"
      Then I should see "Name can't be blank"
      
    Scenario: create a valid category
      Given I am logged in
        And I have a site named "site_a"
      When I go to the create category page for "site_a"
        And I fill in "name" with "texts"
        And I press "Submit"
      Then I should see "Successfully created category"
        And I should be on the category page for "texts" in "site_a"
        And I should see "texts"

    Scenario: edit an category
      Given I am logged in
        And I have a site named "site_a"
        And "site_a" has the following categories
        | name     |
        | category_a |
      When I go to the edit category page for "category_a" in "site_a"
        And I fill in "name" with "category_b"
        And I press "Submit"
      Then I should see "Successfully updated category"
        And I should see "category_b"
      
    Scenario: delete a category
        Given I am logged in
          And I have a site named "site_a"
          And "site_a" has the following categories
          | name     |
          | category_a |
          And I am on the categories page for "site_a"
        Then I should see "category_a"
        
        When I follow "destroy"
        Then I should be on the categories page for "site_a"
          And I should not see "category_a"
