Feature: Android
	In order to build Android Apps
	As a Mobile Developer
	I want to generate Android configuration files

	Scenario: I need an AndroidManifest
		When I have a config.xml file
		And I run "confetti generate android_manifest"
		Then a file named "AndroidManifest.xml" should exist

	Scenario: I need an Android strings.xml file
		When I have a config.xml file
		And I run "confetti generate android_strings"
		Then a file named "strings.xml" should exist
