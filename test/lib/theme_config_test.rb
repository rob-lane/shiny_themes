require 'test_helper'

class ThemeConfigTest < ActiveSupport::TestCase

  def setup
    @original_config = Rails.application.config.theme.clone
    Rails.application.config.theme = nil
    @theme_config = ShinyThemes::ThemeConfig.new
  end

  def teardown
    Rails.application.config.theme = @original_config
  end

  test 'creates new theme config on rails application' do
    refute_nil(Rails.application.config.theme, 'Creating a new config should create an empty theme config')
    assert_kind_of(ActiveSupport::OrderedOptions, Rails.application.config.theme,
                   'Creating a new config should create an ActiveSupport::OrderedOptions object')
  end

  test 'loads theme config from config_pathname' do
    yaml_config = YAML.load(File.open(@theme_config.config_pathname))[Rails.env]
    @theme_config.load
    assert_equal(Rails.application.config.theme.name, yaml_config['name'],
                  'Loading config should populate theme name from YAML file')
    assert_equal(Rails.application.config.theme.layout, yaml_config['layout'],
                  'Loading config should populate theme layout from YAML file')
  end

  test 'saves current config to yaml file' do
    @theme_config.load
    test_theme_name, test_theme_layout = 'dummy_value', 'dummy_layout'
    Rails.application.config.theme.name = test_theme_name
    Rails.application.config.theme.layout = test_theme_layout
    @theme_config.save

    yaml_config = YAML.load(File.open(@theme_config.config_pathname))[Rails.env]
    assert_equal(test_theme_name, yaml_config['name'], 'Saving config should update theme name in YAML file')
    assert_equal(test_theme_layout, yaml_config['layout'], 'Saving config should update theme layout in YAML file')

    Rails.application.config.theme = @original_config
    @theme_config.save
  end
end