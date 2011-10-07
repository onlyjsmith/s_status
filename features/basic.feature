Feature: Set and check my status and see others' even if they are hidden
  In order to find out whether my friends are offline or just invisible
  As a user logged in to Skype
  I want to be able to set and check a different set of statuses, depending on which group they are in
  This could link to Google Circles - let you link Circles people to Skype contacts, and group them for visibility 
  This could link to Facebook - let you link Facebook people to Skype contacts, and group them for visibility     
  
  Scenario: Everyone online 
    Given all my friends are online
    When I check the status page
    Then I should see all my friends with status 'online'
    
  Scenario: Let friend view my real_status
    Given I have a friend called "Steve"  
    When I my skype_status is "offline" and my real_status is "away"
    Then Steve should see that I am "away"
    
  Scenario: Grant access to real_status
    Given I have a friend called "Steve"
    When I approve his access
    Then he should be able to view my real_status

  Scenario: Noone on line
    Given none of my friends are online
    When I check the status page
    Then I should see all my friends with status 'offline'

  Scenario: Some are invisible (or skype_status does not reflect real_status)
    Given some of my friends are invisible
    And they have granted me access to their real_status (or one of a number of real_statuses)  
    When I check the status page
    Then I should see all my friends with their real and actual statuses

  Scenario: I log out of Skype
    Given I was logged in to Skype and to s_status online
    When I log out of Skype
    Then my real_status should be updated to "Offline"
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  

  
