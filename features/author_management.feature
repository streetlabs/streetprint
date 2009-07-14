Feature: Manage my authors
    In order display information on the creators of my items
    As a site user
    I want create/update authors and tag my items to them

    Scenario: friendly notice when error editing author
      Given I am logged in
        And I have a site named "site_a"
        And "site_a" has the following authors
        | name     | description    |
        | author_a | an author      |
      When I go to the edit author page for "author_a" in "site_a"
        And I fill in "name" with ""
        And I press "Submit"
      Then I should see "Name can't be blank"

    Scenario: friendly notice when error creating author
      Given I am logged in
        And I have a site named "site_a"
        And I am on the authors page for "site_a"
      When I follow "New Author"
        And I press "submit"
      Then I should see "Name can't be blank"
      
    Scenario: create a valid author
      Given I am logged in
        And I have a site named "site_a"
      When I go to the create authors page for "site_a"
        And I fill in "name" with "john smith"
        And I fill in "gender" with "male"
        And I fill in "description" with "author description"
        And I press "Submit"
      Then I should see "Successfully created author"
        And I should be on the author page for "john smith" in "site_a"
        And I should see "john smith"
        And I should see "male"
        And I should see "author description"

    Scenario: edit an author
      Given I am logged in
        And I have a site named "site_a"
        And "site_a" has the following authors
        | name     | description    |
        | author_a | an author      |
      When I go to the edit author page for "author_a" in "site_a"
        And I fill in "name" with "author_b"
        And I fill in "description" with "still an author"
        And I press "Submit"
      Then I should see "Successfully updated author"
        And I should see each of "author_b, still an author"
      
    Scenario: delete an author
        Given I am logged in
          And I have a site named "site_a"
          And "site_a" has the following authors
          | name     | description    |
          | author_a | an author      |
          And I am on the authors page for "site_a"
        Then I should see "author_a"
        
        When I follow "destroy"
        Then I should be on the authors page for "site_a"
          And I should not see "author_a"
    