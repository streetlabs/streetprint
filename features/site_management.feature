Feature: Manage my site(s)
    In order to create a website to host my items
    As a regular user
    I want create and update a site
    
    Scenario: set a logo for your site
      Given I am logged in
      When I go to the create site page
        And I fill in "name" with "mock site"
        And I fill in "title" with "mocksite"
        And I fill in "logo" with file "rdoc.png"
        And I press "Create"
      Then the site "mock site" should have the logo "rdoc.png"
    
    Scenario: set the name of my artifacts and plural version
      Given I am logged in
        And I have a site named "mock site"
      When I go to the edit site page for "mock site"
        And I fill in "site_singular_item" with "artifact"
        And I fill in "site_plural_item" with "artifacts"
        And I press "Update"
      Then I should see "Successfully updated site."
        And the site "mock site" field "singular_item" should be "artifact"
        And the site "mock site" field "plural_item" should be "artifacts"
    
    Scenario: featured item and image are used
      Given I am logged in
        And I have a site named "mock site"
        And "mock site" has the following items
        | title  | photos    |
        | item 1 | rails.png |
        | item 2 | rails.png |

        And I go to the item page for "item 2" in "mock site"
        And I press "[set featured]"
      When I go to the site page for "mock site"
      Then I should see a preview of "item 2" with image "rails.png"
    
    Scenario: set the featured image for my site
      Given I am logged in
        And I have a site named "mock site"
        And "mock site" has the following items
        | title  | photos              |
        | item 1 | rails.png, rdoc.png |
        | item 2 | rails.png           |

      When I go to the item page for "item 2" in "mock site"
        And I bring up the photo "rails.png"
        And I press "[set featured]"
      Then I should see "Updated featured item"
        And the featured item and photo for "mock site" should be "item 2" and "rails.png"

    
    Scenario: Set the featured item for my site
      Given I am logged in
        And I have a site named "mock site"
        And "mock site" has the following items
        | title  |
        | item 1 |
        | item 2 |
      When I go to the items page for "mock site"
        And I press the set featured button for "item 1"
      Then I should see "Updated featured item"
        And the featured item for "mock site" should be "item 1"
    
      When I press the set featured button for "item 2"
      Then I should see "Updated featured item"
        And the featured item for "mock site" should be "item 2"
    
    
    Scenario: should see first photo of first item on site show page
      Given I am logged in
        And I have site named "mock site"
        And "mock site" has the following items
        |title|photos|
        |item_1|rails.png|
      When I go to the site page for "mock site"
      Then I should see the first image for "item_1" in "mock site"
    
    Scenario: should be able to assign all required site field
      Given I am logged in
        And I go to the sites page
      When I follow "create a site"
        And I fill in "Title" with "MockSite"
        And I fill in "Name" with "Mock site: name"
        And I fill in "Welcome Message" with "This is the welcome message to mock site"
        And I fill in "About this Site Message" with "Some notes about my project"
        And I fill in "Collection Procedures" with "Some notes about our digitization procedures"
        And I press "create"
      Then I should see "Successfully created site"
      
      When I go to the site page for "Mock site: name"
        Then I should see each of "Mock site: name, This is the welcome message to mock site"
    
    Scenario: create a valid site
      Given I am logged in
        And I go to the sites page
      When I follow "Create a site"
        And I fill in "Name" with "Mock Site"
        And I fill in "title" with "MockSite"
        And I press "Create"
      Then I should see "Successfully created site"
        
    Scenario: fail when given invalid title
      Given I am logged in
        And I go to the sites page
      When I follow "Create a site"
        And I fill in "Name" with "a"
        And I press "Create"
      Then I should see "Name is too short"
      
    Scenario: I should see my sites on the sites page
        Given I am logged in
          And I have sites named "site_a, site_b"
          And I go to the sites page
        Then I should see "site_a"
          And I should see "site_b"
        
    Scenario: I should be able to go to the site page from my account page
        Given I am logged in
          And I have sites named "site_a, site_b"
          And I go to the sites page
          And I follow "site_a"
        Then I should be at the subdomain site page for "site_a"
        
    Scenario: I should be able to view my site
      Given I am logged in
        And I have a site named "site_a"
      When I go to the site page for "site_a"
      Then I should see the site information for "site_a"
            
    Scenario: I should be able to edit a site
      Given I am logged in
        And I have a site named "site_a"
      When I go to the sites page
        And I follow "Site"
        And I fill in "name" with "site_b"
        And I press "Update"
        And I go to the sites page
      Then I should not see "site_a"
      
      When I go to the site page for "site_b"
      Then I should see the site information for "site_b"
      
    Scenario: friendly notice when error editing site
      Given I am logged in
        And I have a site named "site_a"
      When I go to the edit site page for "site_a"
        And I fill in "name" with ""
        And I press "Update"
      Then I should see "Name can't be blank"
      
    Scenario: navigate to the sites items page
      Given I am logged in
        And I have a site named "site_a"
      When I go to the sites page
        And I follow "Items"
      Then I should be on the subdomain items page for "site_a"