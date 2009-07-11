Feature: About page
  In order to show the user some information about my site
  As a site owner
  I want to be able to specify some content to be displayed on the about page
  
  Scenario: Information from the site is displayed on the about page
    Given I am logged in
      And I have the following site
      | name      | about_project                | about_procedures                |
      | mock site | some notes about the project | some notes about the procedures |
    When I go to the about page for site "mock site"
    Then I should see "some notes about the project"
      And I should see "some notes about the procedures"
  