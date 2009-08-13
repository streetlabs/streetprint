Feature: Sub-domains for sites
  In order to have a memorable url to my site
  As a administrator of a streetprint site
  I want to be able to have a domain such as sitetitle.streetprint.org
  
  Scenario: Create a site and navigate to its page based on a subdomain url
    Given I am logged in
      And I have the following site
      | name      | title    |
      | mock site | mocksite |

    When I go to the homepage with subdomain "mocksite"
    
  
  
  
