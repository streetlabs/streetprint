Feature: Visitors to Streetprint.org
  In order to view information about streetprint and view streetprint sites
  As a visitor to streetprint.org without a username
  I want to be able to read about streetprint or select a streetprint site to view

  Scenario: Visitor sees a list of at most 9 streetprint sites available to be viewed.
    Given "Mark" has created the following sites
    | name       | title      | style       |
    | mocksite1  | mocksite1  | default_hex |
    | mocksite2  | mocksite2  | default_hex |
    | mocksite3  | mocksite3  | default_hex |
    | mocksite4  | mocksite4  | default_hex |
    | mocksite5  | mocksite5  | default_hex |
    | mocksite6  | mocksite6  | default_hex |
    | mocksite7  | mocksite7  | default_hex |
    | mocksite8  | mocksite8  | default_hex |
    | mocksite9  | mocksite9  | default_hex |
    | mocksite10 | mocksite10 | default_hex |
    | mocksite11 | mocksite11 | default_hex |

    When I go to the homepage
    Then I should see "mocksite1"
    And I should see "mocksite2"
    And I should see "mocksite3"
    And I should see "mocksite4"
    And I should see "mocksite5"
    And I should see "mocksite6"
    And I should see "mocksite7"
    And I should see "mocksite8"
    And I should see "mocksite9"
    And I should not see "mocksite10"
    And I should not see "mocksite11"
  