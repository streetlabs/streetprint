Feature: Manage account
    In order to use the site
    As a potential or current user
    I want to be able to create and manage an account
    
    Scenario: a new user creates and activates an account
        Given I am on the homepage
        When I follow "register"
        And I fill in "email" with "user@example.com"
        And I fill in "password" with "secret"
        And I fill in "password confirmation" with "secret"
        And I press "register"
        Then I should receive an email
       
        When I open the email
        And I click the first link in the email
        Then I should see "Activate your account"
        
        # clear the email queue due to bug where open_mail doesn't get the most recent email
        Given a clear email queue
        When I press "Activate"
        Then I should receive an email
        
        When I open the email
        Then I should see "Welcome to Streetprint" in the subject
        
        When I click the first link in the email
        Then I should be on the homepage
        
        When I fill in "email" with "user@example.com"
        And I fill in "password" with "secret"
        And I press "login"
        Then I should see "Login successful!"
        And I should be logged in as "user@example.com"
    
    Scenario: an existing user resets their password
        Given I have an active account with email "user@example.com"
        And I am on the homepage
        When I follow "Forgot Password"
        And I fill in "email" with "user@example.com"
        And I press "reset my password"
        Then I should see "Instructions to reset your password have been emailed to you"
        And I should receive an email
        
        When I open the email
        And I click the first link in the email
        Then I should see "Change My Password"
        
        When I fill in "password" with "secret"
        And I fill in "password confirmation" with "secret"
        And I press "Update my password and log me in"
        Then I should see "Password successfully updated"
        And I should be logged in as "user@example.com"
        
    Scenario: a returning user logs in using there credentials
        Given I have an active account with email "user@example.com" and password "pass"
        And I am on the homepage
        And I fill in "email" with "user@example.com"
        And I fill in "password" with "pass"
        And I press "login"
        Then I should see "Login successful!"
        And I should be logged in as "user@example.com"
