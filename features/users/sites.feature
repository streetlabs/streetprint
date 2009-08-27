Feature: Manage my site(s)
    In order to create a website to host my items
    As a regular user
    I want create and update a site
    
  Scenario: set a logo for my site
    Given I am logged in
    When I go to the create site page
      And I fill in "name" with "mocksite"
      And I fill in "title" with "mocksite"
      And I fill in "logo" with file "rdoc.png"
      And I press "Create"
    Then the site "mocksite" should have the logo "rdoc.png"
    
  Scenario: featured item and image are used
    Given I am logged in
      And I have a site titled "mocksite"
      And "mocksite" has the following items
      | title  | photos    |
      | item 1 | rails.png |
      | item 2 | rails.png |

      And I go to the admin item page for "item 2" in "mocksite"
      And I press "[set featured]"
    When I go to the site page for "mocksite"
    Then I should see a preview of "item 2" with image "rails.png"
    
  Scenario: set the featured image for my site
    Given I am logged in
      And I have a site titled "mocksite"
      And "mocksite" has the following items
      | title  | photos              |
      | item 1 | rails.png, rdoc.png |
      | item 2 | rails.png           |

    When I go to the admin item page for "item 2" in "mocksite"
      And I bring up the photo "rails.png"
      And I press "[set featured]"
    Then I should see "Updated featured "
      And the featured item and photo for "mocksite" should be "item 2" and "rails.png"
    
  Scenario: Set the featured item for my site
    Given I am logged in
      And I have a site titled "mocksite"
      And "mocksite" has the following items
      | title  |
      | item 1 |
      | item 2 |
    When I go to the admin items page for "mocksite"
      And I press the set featured button for "item 1"
    Then I should see "Updated featured "
      And the featured item for "mocksite" should be "item 1"

    When I press the set featured button for "item 2"
    Then I should see "Updated featured "
      And the featured item for "mocksite" should be "item 2"
    
  Scenario: should see first photo of first item on site show page if no featured item/photo is set
    Given I am logged in
      And I have site titled "mocksite"
      And "mocksite" has the following items
      | title  | photos    |
      | item_1 | rails.png |

    When I go to the site page for "mocksite"
    Then I should see the first image for "item_1" in "mocksite"

  Scenario: I should see my sites on the sites page
      Given I am logged in
        And I have sites titled "site.a, site.b"
        And I go to the sites page
      Then I should see "site.a"
        And I should see "site.b"
        
  Scenario: I should be able to navigate to the site page from my account page
    Given I am logged in
      And I have sites titled "site.a, site.b"
      And I go to the sites page
      And I follow "site.a"
    Then I should be at the subdomain site page for "site.a"
        
  Scenario: site page should exist displaying site information
    Given "cody" has created the following site
    | title    | name      | logo      | welcome_blurb       |
    | mocksite | mocksite | rails.png | welcome to mocksite |
    
      And "mocksite" has been approved by a moderator
    When I go to the site page for "mocksite"
    Then I should see the site information for "mocksite"
            
  Scenario: edit site fields
    Given "cody" has created the following site
    | title    | name      |
    | mocksite | mocksite |
      
      And I log in as "cody@streetprint.org"
    When I go to the admin page
      And I follow "Site"
      And I fill in "name" with "new name"
      And I press "Update"
    Then the following site should exist
    | title    | name     |
    | mocksite | new name |
    
  Scenario: be able to create a site with all fields
    Given I am logged in
      And I go to the sites page
    When I follow "create a site"
      And I fill in "Title" with "MockSite"
      And I fill in "Name" with "mocksite: name"
      And I fill in "Logo" with file "rails.png"
      And I fill in "site_singular_item" with "artifact"
      And I fill in "site_plural_item" with "artifacts"
      And I fill in "Welcome Message" with "This is the welcome message to mocksite"
      And I fill in "About this Site Message" with "Some notes about my project"
      And I fill in "Collection Procedures" with "Some notes about our digitization procedures"
      And I press "create"
    Then I should see "Successfully created site"
    
  Scenario: fail when given invalid title
    Given I am logged in
      And I go to the sites page
    When I follow "Create a site"
      And I fill in "Name" with "a"
      And I press "Create"
    Then I should see "Name is too short"
    
  Scenario: friendly notice when error editing site
    Given I am logged in
      And I have a site titled "site.a"
    When I go to the edit site page for "site.a"
      And I fill in "name" with ""
      And I press "Update"
    Then I should see "Name can't be blank"