Feature: News
  In order to inform site users of current events related to the site
  As a site administrator
  I want to be able to make news posts to the site and let users read them
  
  Scenario: Administrator can create a new news post
    Given I am logged in
      And I have a site named "mock site"
    When I go to the news page for "mock site"
      And I follow "create new post"
      And I fill in "title" with "Mock news post"
      And I fill in "content" with "This is a mock news post"
      And I press "Create Post"
    Then I should see "Successfully created post"
      And I should be on the subdomain news page for "mock site"
      And I should see "Mock news post"
      And I should see "This is a mock news post"
    
  Scenario: Administrator can edit a post
    Given I am logged in
      And I have a site named "mock site"
      And "mock site" has the following news posts
      | title     | content      |
      | mock news | mock content |

    When I go to the edit news page for "mock news" in "mock site"
      And I fill in "content" with "edited content"
      And I press "Update post"
    Then I should see "Successfully updated post"
      And I should be on the subdomain news page for "mock site"
      And I should see "edited content"
      
      
  Scenario: Should get error when creating post without title or content
    Given I am logged in
      And I have a site named "mock site"
    When I go to the news page for "mock site"
      And I follow "create new post"
      And I press "Create post"
    Then I should see each of "error, prohibited this news post from being saved"  
  
  Scenario: Should get error when updating post and removing title or content
    Given I am logged in
      And I have a site named "mock site"
      And "mock site" has the following news posts
      | title  | content   |
      | post_a | content_a |

    When I go to the edit news page for "post_a" in "mock site"
      And I fill in "title" with ""
      And I press "Update post"
    Then I should see each of "error, prohibited this news post from being saved"  