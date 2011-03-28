Feature: Blackberry
  In order to build Blackberry Apps
	As a Mobile Developer
  I want to generate whatever config files are required

	Scenario: I need a (BB widget) config.xml
		When I have a config.xml file
		And I run "confetti generate blackberry_widgets_config"
		Then a file named "config.xml" should exist
