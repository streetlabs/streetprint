Feature: Manage my site(s)
    In order to create a website to host my items
    As a regular user
    I want create and update a site
    
    Scenario: create a site
        Given I am logged in
          And I visit my account page
        When I follow "Create a site"
          And I fill in "Name" with "Mock Site"
          And I press "Create"
        Then I should see "Successfully created site"
        
    Scenario: I should see my sites on my account page
        Given I am logged in
          And I have sites named "site_a, site_b"
          And I visit my account page
        Then I should see "site_a"
          And I should see "site_b"
        
    Scenario: I should be able to go to the site page from my account page
        Given I am logged in
          And I have sites named "site_a, site_b"
          And I visit my account page
          And I follow "site_a"
        Then I should be at the site page for "site_a"
        
    Scenario: I should be able to view a sites settings
        Given I am logged in
          And I have sites named "site_a"
        When I visit the site page for "site_a"
        # Then I should see "site_b"
          