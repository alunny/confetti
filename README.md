# Confetti

## How to Add a New Platform

Let's say you want write a `nintendo_ds_config` generator:

* create a feature file, like `features/nintendo.feature`
  * specify all the files to generate for your platform
  * specify the name each file will go under
    * `nintendo_ds_config`
  * and the default filename
    * `NintendoDSConfig.xml`
  * run `rake features` to verify that it fails
* add a sample configuration file to `spec/fixtures`
  * the filename is based on the descriptive name
    * `nintendo_ds_config_expected.xml`
* add some failing specs
  * copy one of the existing specs from `spec/templates`
    * `cp android_manifest_spec.rb nintendo_ds_config_spec.rb`
  * modify the new file to match your new template
    * this isn't as well automated as we'd like
  * run `rake spec` to verify that they fail
* create your view class
  * as `lib/confetti/templates/nintendo_ds_config.rb`
  * should define `Confetti::Template::NintendoDsConfig < Base`
* create your template file
  * copy your expected config into `lib/confetti/templates`
    * as `nintendo_ds_config.mustache`
  * replace the variable sections with mustache tags
* in your view class
  * write methods that correspond to the variable sections in your template
* run `rake spec` to ensure everything was set up correctly
* add specs for generate and write methods
  * open `spec/config_spec.rb`
  * add the following line to the `describe config generation` block
    * `it_should_have_generate_and_write_methods_for :nintendo_ds_config`
* run `rake spec`, see them fail
* add generate and write methods
  * open lib/confetti/config.rb
  * add your platform to the `generate_and_write` call
    * `generate_and_write ... :nintendo_ds_config`
* run `rake spec` again
* build and install the gem, or whatever, so the cucumber tests work
* run `feature/nintendo.feature`
  * it's all green!
  * you're the man now dog
