require 'test_helper'
require 'fileutils'

class ThemeTest < ActiveSupport::TestCase
  include ThemeTestHelper

  def setup
    @theme_name, @layout_name = 'temp_theme', 'temp_layout'
    ShinyThemes::Engine.theme_config.load
    # Create theme directories
    build_theme_dir(@theme_name)
  end

  def teardown
    @theme = nil
    # Destroy root theme directory
    cleanup_theme_dir(@theme_name)
    # Reload the default config after any test modifications
    ShinyThemes::Engine.theme_config.load
  end

  def theme
    @theme ||= ShinyThemes::Theme.new(name: @theme_name, layout: @layout_name)
  end

  test "is valid with name, layout and valid directory structure" do
    assert(theme.valid?, 'Theme with name, layout and valid directory structure should be valid')
  end

  test "theme is invalid without name" do
    original_theme_name, @theme_name = @theme_name, ''
    refute(theme.valid?, 'Theme without a name should not be valid')
    assert_includes(theme.errors.keys, :name, 'Theme without a name should have a "name" related error')
    @theme_name = original_theme_name
  end

  test "theme is invalid without a layout" do
    @layout_name = ''
    refute(theme.valid?, 'Theme without a layout should not be valid')
    assert_includes(theme.errors.keys, :layout, 'Theme without a layout should have a "layout" related error')
  end

  test "theme is invalid without any directories" do
    cleanup_theme_dir(@theme_name)
    refute(theme.valid?, 'Theme without a valid directory structure should not be valid')
    assert_includes(theme.errors.keys, :base, 'Theme without a valid directory structure should have a "base" related error')
  end

  test "theme is invalid without a views directory" do
    FileUtils.rmtree(theme_root.join(@theme_name, 'views'))
    refute(theme.valid?, 'Theme without a views directory should not be valid')
    assert_includes(theme.errors.keys, :base, 'Theme without a views directory should have a "base" related error')
  end

  test "theme is invalid without an assets directory" do
    FileUtils.rmtree(theme_root.join(@theme_name, 'assets'))
    refute(theme.valid?, 'Theme without a views directory should not be valid')
    assert_includes(theme.errors.keys, :base, 'Theme without an assets directory should have a "base" related error')
  end

  test "theme is invalid without an assets/images directory" do
    FileUtils.rmtree(theme_root.join(@theme_name, 'assets', 'images'))
    refute(theme.valid?, 'Theme without an assets/images directory should not be valid')
    assert_includes(theme.errors.keys, :base, 'Theme without an assets/images directory should have a "base" related error')
  end

  test "theme is invalid without an assets/stylesheets directory" do
    FileUtils.rmtree(theme_root.join(@theme_name, 'assets', 'stylesheets'))
    refute(theme.valid?, 'Theme without an assets/stylesheets directory should not be valid')
    assert_includes(theme.errors.keys, :base, 'Theme without an assets/stylesheets directory should have a "base" related error')
  end

  test "theme is invalid without an assets/javascripts directory" do
    FileUtils.rmtree(theme_root.join(@theme_name, 'assets', 'javascripts'))
    refute(theme.valid?, 'Theme without an assets/javascripts directory should not be valid')
    assert_includes(theme.errors.keys, :base, 'Theme without an assets/javascripts directory should have a "base" related error')
  end

  test "theme is invalid without a images asset namespace directory" do
    FileUtils.rmtree(theme_root.join(@theme_name, 'assets', 'images', @theme_name))
    refute(theme.valid?, 'Theme without an assets/images directory should not be valid')
    assert_includes(theme.errors.keys, :base, 'Theme without an assets/images directory should have a "base" related error')
  end

  test "theme is invalid without a stylesheets asset namespace directory" do
    FileUtils.rmtree(theme_root.join(@theme_name, 'assets', 'stylesheets', @theme_name))
    refute(theme.valid?, 'Theme without an assets/images directory should not be valid')
    assert_includes(theme.errors.keys, :base, 'Theme without an assets/images directory should have a "base" related error')
  end

  test "theme is invalid without a javascripts asset namespace directory" do
    FileUtils.rmtree(theme_root.join(@theme_name, 'assets', 'javascripts', @theme_name))
    refute(theme.valid?, 'Theme without an assets/images directory should not be valid')
    assert_includes(theme.errors.keys, :base, 'Theme without an assets/images directory should have a "base" related error')
  end

  test "uses theme configuration for default name" do
    refute_nil(Rails.application.config.theme.name)
    original_theme_name, @theme_name = @theme_name, nil
    assert_equal(Rails.application.config.theme.name, theme.name, 'Theme name should default to config.theme.name value')
    @theme_name = original_theme_name
  end

  test "uses theme configuration for default layout" do
    refute_nil(Rails.application.config.theme.layout)
    @layout_name = nil
    assert_equal(Rails.application.config.theme.layout, theme.layout, 'Theme layout should defualt to config.theme.layout value')
  end

  test "uses application for default layout when config value is missing" do
    Rails.application.config.theme.layout = nil
    @layout_name = nil
    assert_equal('application', theme.layout, 'Theme layout should default to "application" when config value not present')
  end
end