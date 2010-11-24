When /^I'm in the fixtures directory$/ do
  @dirs = []
  fixtures_dir = File.join(File.dirname(__FILE__), '..', '..', 'spec', 'fixtures')
  fixtures_dir = File.expand_path(fixtures_dir)
  cd fixtures_dir
end
