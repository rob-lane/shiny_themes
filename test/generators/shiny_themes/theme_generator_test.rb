require 'test_helper'
require 'generators/shiny_themes/theme_generator'

class ThemeGeneratorTest < Rails::Generators::TestCase
  tests ShinyThemes::Generators::ThemeGenerator
  destination Rails.root.join('tmp')

  def setup
    prepare_destination
    @theme_name, @layout_name = 'temp_theme', 'temp_layout'
  end

  def theme_directory
    Pathname.new(File.join('app', 'themes', @theme_name))
  end

  test 'creates layout directory' do
    run_generator([@theme_name, "--layout=#{@layout_name}"])
    assert_file(theme_directory.join('views', 'layouts'))
  end

  test 'creates images directory' do
    run_generator([@theme_name, "--layout=#{@layout_name}"])
    assert_file(theme_directory.join('assets', 'images', @theme_name, '.gitkeep'))
  end

  test 'creates javascripts directory' do
    run_generator([@theme_name, "--layout=#{@layout_name}"])
    assert_file(theme_directory.join('assets', 'javascripts', @theme_name, '.gitkeep'))
  end

  test 'creates stylesheets directory' do
    run_generator([@theme_name, "--layout=#{@layout_name}"])
    assert_file(theme_directory.join('assets', 'stylesheets', @theme_name, '.gitkeep'))
  end

  test 'creates JS manifest' do
    run_generator([@theme_name, "--layout=#{@layout_name}"])
    assert_file(theme_directory.join('assets', 'javascripts', @theme_name, 'manifest.js'))
  end

  test 'creates CSS manifest when sass is false' do
    run_generator([@theme_name, "--layout=#{@layout_name}"])
    assert_file(theme_directory.join('assets', 'stylesheets', @theme_name, 'manifest.css'))
  end

  test 'creates an SCSS manifest when sass is true' do
    run_generator([@theme_name, "--layout=#{@layout_name}", "--sass"])
    assert_file(theme_directory.join('assets', 'stylesheets', @theme_name, 'manifest.scss'))
  end

  test 'creates a layout using the name provided' do
    run_generator([@theme_name, "--layout=#{@layout_name}"])
    assert_file(theme_directory.join('views', 'layouts', "#{@layout_name}.html.erb"))
  end

end