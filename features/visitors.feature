Feature: Visitors to Streetprint.org
  In order to view information about streetprint and view streetprint sites
  As a visitor to streetprint.org without a username
  I want to be able to read about streetprint or select a streetprint site to view

  Scenario: Visitor sees a list of at most 10 streetprint sites available to be viewed.
    Given "Mark" has created the following sites
    | name       | title      | style       | approved | logo      |
    | mocksite1  | mocksite1  | default_hex | true     | rails.png |
    | mocksite2  | mocksite2  | default_hex | false    | rails.png |
    | mocksite3  | mocksite3  | default_hex | true     | rails.png |
    | mocksite4  | mocksite4  | default_hex | true     | rails.png |
    | mocksite5  | mocksite5  | default_hex | true     | rails.png |
    | mocksite6  | mocksite6  | default_hex | true     | rails.png |
    | mocksite7  | mocksite7  | default_hex | true     | rails.png |
    | mocksite8  | mocksite8  | default_hex | true     | rails.png |
    | mocksite9  | mocksite9  | default_hex | true     | rails.png |
    | mocksite10 | mocksite10 | default_hex | true     | rails.png |
    | mocksite11 | mocksite11 | default_hex | true     | rails.png |
    | mocksite12 | mocksite12 | default_hex | true     | rails.png |

    When I go to the homepage
    Then I should see the logo for "mocksite1"
    And I should not see the logo for "mocksite2"
    And I should see the logo for "mocksite3"
    And I should see the logo for "mocksite4"
    And I should see the logo for "mocksite5"
    And I should see the logo for "mocksite6"
    And I should see the logo for "mocksite7"
    And I should see the logo for "mocksite8"
    And I should see the logo for "mocksite9"
    And I should see the logo for "mocksite10"
    And I should see the logo for "mocksite11"
    And I should not see the logo for "mocksite12"
  