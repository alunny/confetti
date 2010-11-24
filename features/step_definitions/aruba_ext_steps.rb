When /^I have a config.xml file$/ do
  fixtures_dir = File.join(File.dirname(__FILE__), '..', '..', 'spec', 'fixtures')
  fixtures_dir = File.expand_path(fixtures_dir)
  config_fixture = File.read(File.join(fixtures_dir, "config.xml"))

  create_file("config.xml", config_fixture)
end
