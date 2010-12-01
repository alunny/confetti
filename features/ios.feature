Feature: iOS
	In order to build iOS Apps
	As a Mobile Developer
	I want to generate the iOS configuration files

	Scenario: I need an Info.plist
		When I have a config.xml file
		And I run "confetti generate ios_info"
		Then a file named "Info.plist" should exist
