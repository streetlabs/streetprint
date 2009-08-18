Feature: Manage document types
    In order to give items document types
    As a site user
    I want to create/manage document types and tag items with them
    
    Scenario: should only get document type option when there is at least one document type
      Given I am logged in
        And I have a site titled "site.a"
      When I go to the create item page for "site.a"
      Then I should not see "Document Type"

    Scenario: friendly notice when error editing
      Given I am logged in
        And I have a site titled "site.a"
        And "site.a" has the following document types
        | name   | description |
        | type_a | a type      |
      When I go to the edit document type page for "type_a" in "site.a"
        And I fill in "name" with ""
        And I press "Submit"
      Then I should see "Name can't be blank"

    Scenario: friendly notice when error creating document type
      Given I am logged in
        And I have a site titled "site.a"
        And I am on the document types page for "site.a"
      When I follow "New Document Type"
        And I press "submit"
      Then I should see "Name can't be blank"
      
    Scenario: create a valid document type
      Given I am logged in
        And I have a site titled "site.a"
      When I go to the create document type page for "site.a"
        And I fill in "name" with "texts"
        And I press "Submit"
      Then I should see "Successfully created document type"
        And I should be on the subdomain document type page for "texts" in "site.a"
        And I should see "texts"

    Scenario: edit a document type
      Given I am logged in
        And I have a site titled "site.a"
        And "site.a" has the following document types
        | name     |
        | type_a |
      When I go to the edit document type page for "type_a" in "site.a"
        And I fill in "name" with "type_b"
        And I press "Submit"
      Then I should see "Successfully updated document type"
        And I should see "type_b"
      
    Scenario: delete a document type
        Given I am logged in
          And I have a site titled "site.a"
          And "site.a" has the following document types
          | name     |
          | type_a |
          And I am on the document types page for "site.a"
        Then I should see "type_a"
        
        When I follow "destroy"
        Then I should be on the subdomain document types page for "site.a"
          And I should not see "type_a"
