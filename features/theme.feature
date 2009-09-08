Feature: themes!
  In order to customize the look and feel of my site
  As a site creator with some web design knowledge
  I want to be able to create a custom theme for my site
  
  Scenario: Themes images should display path to image
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name    | images    | user |
      | mock theme | rails.png | cody@streetprint.org |
    When I go to the edit theme page for "mock theme"
    Then I should see "rails.png"
      And I should see the path to the image "rails.png" for theme "mock theme"
  
  Scenario: Add images to a theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name       | user |
      | mock theme | cody@streetprint.org |

    When I go to the edit theme page for "mock theme"
      And I fill in "image" with file "rails.png"
      And I press "Upload Image"

      And I fill in "image" with file "rdoc.png"
      And I press "Upload Image"
      
    Then theme "mock theme" should have image "rails.png"
      And theme "mock theme" should have image "rdoc.png"
    
    When I go to the edit theme page for "mock theme"
    Then there should be a link to "rails.png"
      And there should be a link to "rdoc.png"
      
  Scenario: Remove images from a theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name    | images    | user |
      | mock theme | rails.png | cody@streetprint.org |

    When I go to the edit theme page for "mock theme"
      And I click the remove image link for "rails.png"
    Then theme "mock theme" should not have any images
    
  Scenario: Create a theme
    Given I am logged in
    When I go to the new theme page
      And I fill in "name" with "Mock Theme"
      And I fill in "icon" with file "rails.png"
      And I press "Create"
    Then I should be on the edit theme page for "Mock Theme"
      
  Scenario: Edit a theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name            | icon  | user |
      | Cody's theme | rails.png | cody@streetprint.org |
    When I go to the edit theme page for "Cody's theme"
      And I fill in "name" with "New theme"
      And I fill in "icon" with file "rdoc.png"
      And I press "Update"
    Then the following theme should exist
    | name         | icon     |
    | New theme | rdoc.png |
    
  Scenario: Delete a theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      |name| user |
      |theme 1| cody@streetprint.org |
    When I go to the themes page
      And I follow "Delete"
    Then the theme "theme 1" should not exist
    
  Scenario: list all theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following themes
      | name      | user |
      | theme 1 | cody@streetprint.org |
      | theme 2 | cody@streetprint.org |
      | theme 3 | cody@streetprint.org |
      
    When I go to the themes page
    Then I should see each of "theme 1, theme 2, theme 3"
    
  Scenario: Edit the layout for the theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name          | user |
      | Mock Theme | cody@streetprint.org |
    When I go to the edit theme page for "Mock Theme"
      And I follow "Layout"
      And I fill in "template" with "{{ site.name }}"
      And I fill in "css" with "body { display: none; }"
      And I press "Save"
      And the following theme should exist
      | name       | page   | template        | css                     |
      | Mock Theme | layout | {{ site.name }} | body { display: none; } |
      
    When I go to the edit theme page for "Mock Theme" 
      And I follow "Layout"
      And I fill in "template" with "{{"
      And I press "Save"
    Then I should see "Template has the liquid syntax error:"
      
  Scenario: Edit the home page for the theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name          |user |
      | Mock Theme |   cody@streetprint.org |
    When I go to the edit theme page for "Mock Theme"
      And I follow "Home page"
      And I fill in "template" with "{{ site.name }}"
      And I fill in "css" with "body { display: none; }"
      And I press "Save"
      And the following theme should exist
      | name          | page      | template        | css                     |
      | Mock Theme | show_site | {{ site.name }} | body { display: none; } |
      
    When I go to the edit theme page for "Mock Theme" 
      And I follow "Home page"
      And I fill in "template" with "{{"
      And I press "Save"
    Then I should see "Template has the liquid syntax error:"

  Scenario: Edit the about page for the theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name          |user |
      | Mock Theme |   cody@streetprint.org |
    When I go to the edit theme page for "Mock Theme"
      And I follow "About page"
      And I fill in "template" with "{{ site.name }}"
      And I fill in "css" with "body { display: none; }"
      And I press "Save"
      And the following theme should exist
      | name          | page       | template        | css                     |
      | Mock Theme | show_about | {{ site.name }} | body { display: none; } |
      
    When I go to the edit theme page for "Mock Theme" 
      And I follow "About page"
      And I fill in "template" with "{{"
      And I press "Save"
    Then I should see "Template has the liquid syntax error:"

  Scenario: Edit the news page for the theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name          |user |
      | Mock Theme |   cody@streetprint.org |
    When I go to the edit theme page for "Mock Theme"
      And I follow "News page"
      And I fill in "template" with "{{ site.name }}"
      And I fill in "css" with "body { display: none; }"
      And I press "Save"
      And the following theme should exist
      | name          | page            | template        | css                     |
      | Mock Theme | show_news_posts | {{ site.name }} | body { display: none; } |
      
    When I go to the edit theme page for "Mock Theme" 
      And I follow "News page"
      And I fill in "template" with "{{"
      And I press "Save"
    Then I should see "Template has the liquid syntax error:"

  Scenario: Edit the artifact page for the theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name          |user |
      | Mock Theme |   cody@streetprint.org |
    When I go to the edit theme page for "Mock Theme"
      And I follow "Show artifact page"
      And I fill in "template" with "{{ site.name }}"
      And I fill in "css" with "body { display: none; }"
      And I press "Save"
      And the following theme should exist
      | name          | page          | template        | css                     |
      | Mock Theme | show_artifact | {{ site.name }} | body { display: none; } |
      
    When I go to the edit theme page for "Mock Theme" 
      And I follow "Show artifact page"
      And I fill in "template" with "{{"
      And I press "Save"
    Then I should see "Template has the liquid syntax error:"

  Scenario: Edit the browse artifacts page for the theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name          | user |
      | Mock Theme |    cody@streetprint.org |
    When I go to the edit theme page for "Mock Theme"
      And I follow "Browse artifacts page"
      And I fill in "template" with "{{ site.name }}"
      And I fill in "css" with "body { display: none; }"
      And I press "Save"
      And the following theme should exist
      | name          | page             | template        | css                     |
      | Mock Theme | browse_artifacts | {{ site.name }} | body { display: none; } |
      
    When I go to the edit theme page for "Mock Theme" 
      And I follow "Browse artifacts page"
      And I fill in "template" with "{{"
      And I press "Save"
    Then I should see "Template has the liquid syntax error:"

  Scenario: Edit the search artifacts page for the theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name          | user |
      | Mock Theme | cody@streetprint.org |
    When I go to the edit theme page for "Mock Theme"
      And I follow "Search artifacts page"
      And I fill in "template" with "{{ site.name }}"
      And I fill in "css" with "body { display: none; }"
      And I press "Save"
      And the following theme should exist
      | name          | page             | template        | css                     |
      | Mock Theme | index_artifacts  | {{ site.name }} | body { display: none; } |
      
    When I go to the edit theme page for "Mock Theme" 
      And I follow "Search artifacts page"
      And I fill in "template" with "{{"
      And I press "Save"
    Then I should see "Template has the liquid syntax error:"

  Scenario: Edit the show author page for the theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name          | user |
      | Mock Theme | cody@streetprint.org |
    When I go to the edit theme page for "Mock Theme"
      And I follow "Show author page"
      And I fill in "template" with "{{ site.name }}"
      And I fill in "css" with "body { display: none; }"
      And I press "Save"
      And the following theme should exist
      | name          | page        | template        | css                     |
      | Mock Theme | show_author | {{ site.name }} | body { display: none; } |
      
    When I go to the edit theme page for "Mock Theme" 
      And I follow "Show author page"
      And I fill in "template" with "{{"
      And I press "Save"
    Then I should see "Template has the liquid syntax error:"

  Scenario: Edit the full text page for the theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name          | user |
      | Mock Theme | cody@streetprint.org |
    When I go to the edit theme page for "Mock Theme"
      And I follow "Full text page"
      And I fill in "template" with "{{ site.name }}"
      And I fill in "css" with "body { display: none; }"
      And I press "Save"
      And the following theme should exist
      | name          | page           | template        | css                     |
      | Mock Theme | show_full_text | {{ site.name }} | body { display: none; } |
      
    When I go to the edit theme page for "Mock Theme" 
      And I follow "Full text page"
      And I fill in "template" with "{{"
      And I press "Save"
    Then I should see "Template has the liquid syntax error:"
      
  Scenario: Edit the google location page for the theme
    Given I am logged in as "cody@streetprint.org"
      And I have the following theme
      | name          | user |
      | Mock Theme | cody@streetprint.org |
    When I go to the edit theme page for "Mock Theme"
      And I follow "Google location page"
      And I fill in "template" with "{{ site.name }}"
      And I fill in "css" with "body { display: none; }"
      And I press "Save"
      And the following theme should exist
      | name          | page                 | template        | css                     |
      | Mock Theme | show_google_location | {{ site.name }} | body { display: none; } |
      
    When I go to the edit theme page for "Mock Theme" 
      And I follow "Google location page"
      And I fill in "template" with "{{"
      And I press "Save"
    Then I should see "Template has the liquid syntax error:"
    