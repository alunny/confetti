Feature: webOS
	In order to build webOS Apps
	As a Mobile Developer
	I want to generate the webOS configuration files

	Scenario: I need a appinfo.json
		When I have a config.xml file
		And I run "confetti generate webos_appinfo"
		Then a file named "appinfo.json" should exist
