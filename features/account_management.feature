Feature: Manage account
    In order to use the site
    As a potential or current user
    I want to be able to create and manage an account
    
    Scenario: a new user creates and activates an account
        Given I am on the homepage
        When I follow "Register"
        And I fill in "email" with "user@example.com"
        And I fill in "password" with "secret"
        And I fill in "password confirmation" with "secret"
        And I press "Register"
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
    
    Scenario: an existing user resets their password using there email
        Given I have an active account with email "user@example.com"
        And I am on the homepage
        When I follow "Forgot Password"
        And I fill in "email" with "user@example.com"
        And I press "Reset my password"
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
        And I press "Login"
        Then I should see "Login successful!"
        And I should be logged in as "user@example.com"
    
    Scenario: a returning user fails to log in using the wrong password
        Given I have an active account with email "user@example.com" and password "pass"
        And I am on the homepage
        And I fill in "email" with "user@example.com"
        And I fill in "password" with "passs"
        And I press "Login"
        Then I should see "not valid"
        And I should not be logged in
        
    Scenario: a new user tries to register an existing email
      Given I have an account with email "user@example.com"
        And I am on the register page
      When I fill in "email" with "user@example.com"
        And I press "Register"
      Then I should see "Email has already been taken"
      
    Scenario: a current user is able to change their password
      Given I am logged in as "user@example.com"
      When I go to my account page
        And I follow "Change password"
        And I fill in "New password" with "abcdef"
        And I fill in "password confirmation" with "abcdef"
        And I press "Update"
      Then I should see "Account updated"
      And I should be able to login as "user@example.com" with password "abcdef"
      
    Scenario: a current user fails to update their password if the confirmation doesn't match
      Given I am logged in as "user@example.com"
      When I go to my account page
        And I follow "Change password"
        And I fill in "New password" with "abcdefg"
        And I fill in "password confirmation" with "abcdef"
        And I press "Update"
      Then I should see "Password doesn't match confirmation"
      
    Scenario: password reset should fail if email doesn't exist
      Given I am on the forgot password page
      When I fill in "email" with "fake_user@example.com"
      And I press "Reset my password"
      Then I should see "No user was found with that email address"

    Scenario: password reset should force passwords to match
        Given I have an active account with email "user@example.com"
        And I am on the homepage
        When I follow "Forgot Password"
        And I fill in "email" with "user@example.com"
        And I press "Reset my password"
        Then I should see "Instructions to reset your password have been emailed to you"
        And I should receive an email

        When I open the email
        And I click the first link in the email
        Then I should see "Change My Password"

        When I fill in "password" with "secret"
        And I fill in "password confirmation" with "secrett"
        And I press "Update my password and log me in"
        Then I should see "Password doesn't match confirmation"
        
    Scenario: password reset should give friendly notice if perishable token is lost
        Given I have an active account with email "user@example.com"
        And I am on the homepage
        When I follow "Forgot Password"
        And I fill in "email" with "user@example.com"
        And I press "Reset my password"
        Then I should see "Instructions to reset your password have been emailed to you"
        And I should receive an email
        
        Given the perishable token for "user@example.com" is reset
        
        When I open the email
        And I click the first link in the email
        Then I should see "We're sorry, but we could not locate your account."
          And I should see "If you are having issues try copying and pasting the URL "
          And I should see "from your email into your browser or restarting the "
          And I should see "reset password process."
        