Feature: Android
	In order to build Android Apps
	As a Mobile Developer
	I want to generate Android configuration files

	Scenario: I need an AndroidManifest
		When I'm in the fixtures directory
		And I run "confetti generate android_manifest"
		Then a file named "AndroidManifest.xml" should exist
