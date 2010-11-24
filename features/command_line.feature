Feature: Command Line
  In order to generate mobile configurations
  As a PhoneGap Developer
  I want to use the Confetti CLI

  Scenario: I want an unsupported type
    When I have a config.xml file
    And I run "confetti generate microsoft_word"
    Then it should fail with:
      """
      microsoft_word unsupported
      """
