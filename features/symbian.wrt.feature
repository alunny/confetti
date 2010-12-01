Feature: Symbian.wrt
  In order to build Symbian.wrt Apps
	As a Mobile Developer
  I want to generate the Symbian.wrt configuration files

	Scenario: I need an info.plist
		When I have a config.xml file
		And I run "confetti generate symbian_wrt_info"
		Then a file named "info.plist" should exist
