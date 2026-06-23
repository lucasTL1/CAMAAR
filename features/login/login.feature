Feature: User Login

  Scenario: Successful Login
    Given the user is on the login page
    When the user fills "valid_username" in the username field
    And the user fills "valid_password" in the password field
    Then the user should be redirected to the dashboard

  Scenario: Unsuccessful Login
    Given the user is on the login page
    When the user fills "invalid_username" in the username field
    And the user fills "invalid_password" in the password field
    Then I should see the message "Invalid username or password"

  Scenario: Empty Fields
    Given the user is on the login page
    When the user leaves "username" field empty
    And the user leaves "password" field empty
    Then I should see the message "Fields cannot be empty"