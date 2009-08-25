Feature: News
  In order to inform site users of current events related to the site
  As a site administrator
  I want to be able to make news posts to the site and let users read them
  
  Scenario: Administrator can create a new news post
    Given I am logged in
      And I have a site titled "mocksite"
    When I go to the create news page for "mocksite"
      And I fill in "title" with "Mock news post"
      And I fill in "content" with "This is a mock news post"
      And I press "Create Post"
    Then I should see "Successfully created post"
      And I should be on the admin subdomain news page for "mocksite"
      And I should see "Mock news post"
      And I should see "This is a mock news post"
    
  Scenario: Administrator can edit a post
    Given I am logged in
      And I have a site titled "mocksite"
      And "mocksite" has the following news posts
      | title     | content      |
      | mock news | mock content |

    When I go to the edit news page for "mock news" in "mocksite"
      And I fill in "content" with "edited content"
      And I press "Update post"
    Then I should see "Successfully updated post"
      And I should be on the admin subdomain news page for "mocksite"
      And I should see "edited content"
      
      
  Scenario: Should see listing of news posts on news posts page
    Given I am logged in
      And I have a site titled "mocksite"
      And "mocksite" has the following news posts
      | title  | content   |
      | post a | content a |
      | post b | content b |
      | post c | content c |
      | post d | content d |
    When I go to the news page for "mocksite"
    Then I should see each of "post a, post b, post c, post d"
      And I should see each of "content a, content b, content c, content d"
      
      
  Scenario: Should get error when creating post without title or content
    Given I am logged in
      And I have a site titled "mocksite"
    When I go to the create news page for "mocksite"
      And I press "Create post"
    Then I should see each of "error, prohibited this news post from being saved"  
  
  Scenario: Should get error when updating post and removing title or content
    Given I am logged in
      And I have a site titled "mocksite"
      And "mocksite" has the following news posts
      | title  | content   |
      | post_a | content_a |

    When I go to the edit news page for "post_a" in "mocksite"
      And I fill in "title" with ""
      And I press "Update post"
    Then I should see each of "error, prohibited this news post from being saved"  