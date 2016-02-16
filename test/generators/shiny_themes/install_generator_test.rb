require 'test_helper'
require 'generators/shiny_themes/install_generator'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests ShinyThemes::Generators::InstallGenerator
  destination Rails.root.join('tmp')

  def setup
    prepare_destination
    run_generator
  end
  setup :prepare_destination

  test "it copies the theme configuration" do
    assert_file "config/theme.yml"
  end

  test "it creates a theme directory" do
    assert_file "app/themes"
  end
end