Feature: Custom styles
  In order make my site look the way I want
  As a user who has created a site but doesn't like the default style
  I want to be able to choose from other styles and be able to roll my own
  
  Scenario: User can select a style from a list of options for their site
    Given I am logged in
    And I have the following sites
    | name   | title  |
    | site a | site a |
    | site b | site b |

    When I go to the style page for "site a"
      And I press "use parchment"
    Then I should see "Successfully updated style."
    
    When I go to the site page for "site a"
    Then there should be a link to the "parchment" stylesheet

  
  Scenario: style sheet link is based off of the sites style attribute
    Given I am logged in
    And I have the following site
    | name     | title    | style       |
    | mocksite | mocksite | default_hex |

    When I go to the site page for "mocksite"
    Then there should be a link to the "default_hex" stylesheet

    Given I have the following site
    | name        | title       |
    | anothersite | anothersite |
    
    When I go to the site page for "anothersite"
    Then there should be a link to the "default" stylesheet
