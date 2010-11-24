When /^I'm in the fixtures directory$/ do
  @dirs = []
  fixtures_dir = File.join(File.dirname(__FILE__), '..', '..', 'spec', 'fixtures')
  fixtures_dir = File.expand_path(fixtures_dir)
  cd fixtures_dir
end

Then /^the "([^"]*)" file should be identical to "([^"]*)"$/ do |file_one, file_two|
  other_file = File.read(File.join(current_dir, file_two))
  check_exact_file_content(file_one, other_file)
end
