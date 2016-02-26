require 'test_helper'

class EngineTest < ActiveSupport::TestCase
  include ThemeTestHelper

  def setup
    # Reload theme config
    ShinyThemes::Engine.theme_config.load
    @themes_path = Rails.root.join(Rails.application.config.theme.path)
    # Grab all directory names in themes_path to get all installed theme names
    @theme_names = Dir.glob(@themes_path.join('*/')).map{ |fn| Pathname.new(fn).basename }
    @theme_config = YAML.load_file(Rails.root.join('config', 'theme.yml'))[Rails.env]
  end

  test 'theme config ordered options created' do
    assert_instance_of(ActiveSupport::OrderedOptions, Rails.application.config.theme,
                       'Theme config should be an ordered options instance')
  end

  test 'default theme path configured' do
    assert_equal(File.join('app', 'themes'), Rails.application.config.theme.path)
  end

  test 'theme asset directories configured' do
    assert_includes(Rails.application.config.theme.asset_directories, 'images',
                    'Images must be part of theme asset_directories by default')
    assert_includes(Rails.application.config.theme.asset_directories, 'stylesheets',
                    'Stylesheets must be part of theme asset_directories by default')
    assert_includes(Rails.application.config.theme.asset_directories, 'javascripts',
                    'Javascripts must be part of theme asset_directories by default')
  end

  test 'theme name configured from yml file' do
    assert_equal(@theme_config[:name], Rails.application.config.theme.name, 'Theme name in config must match theme.yml')
  end

  test 'theme layout configured from yml file' do
    assert_equal(@theme_config[:layout], Rails.application.config.theme.layout, 'Theme layout in config must match theme.yml')
  end

  test 'all themes asset images directories added to assets path' do
    @theme_names.each do |theme_name|
      assert_includes(Rails.application.config.assets.paths, @themes_path.join(theme_name, 'assets', 'images').to_s,
                      'Asset path should include images directories for all themes')
      assert_includes(Rails.application.config.assets.paths, @themes_path.join(theme_name, 'assets', 'images', theme_name).to_s,
                      'Asset path should include images namespaced directories for all themes')
    end
  end

  test 'all themes asset javascripts directories added to assets path' do
    @theme_names.each do |theme_name|
      assert_includes(Rails.application.config.assets.paths, @themes_path.join(theme_name, 'assets', 'javascripts').to_s,
                      'Asset path should include javascripts directories for all themes')
      assert_includes(Rails.application.config.assets.paths, @themes_path.join(theme_name, 'assets', 'javascripts', theme_name).to_s,
                      'Asset path should include javascripts namespaced directories for all themes')
    end
  end

  test 'all themes asset stylesheets directories added to assets path' do
    @theme_names.each do |theme_name|
      assert_includes(Rails.application.config.assets.paths, @themes_path.join(theme_name, 'assets', 'stylesheets').to_s,
                      'Asset path should include stylesheets directories for all themes')
      assert_includes(Rails.application.config.assets.paths, @themes_path.join(theme_name, 'assets', 'stylesheets', theme_name).to_s,
                      'Asset path should include stylesheets namespaced directories for all themes')
    end
  end

  test 'includes RendersTheme in application controller' do
    assert_respond_to(ApplicationController, :renders_theme)
    assert_respond_to(ApplicationController, :theme)
  end

end