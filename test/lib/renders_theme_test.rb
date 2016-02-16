require 'test_helper'

module ShinyThemes
  include ::ThemeTestHelper
  class TestController < ActionController::Base
    def test
      render 'test'
    end
  end

  # If disable_clear_and_finalize is set to true, Rails will not clear other routes when calling again the draw method. Look at the source code at: http://apidock.com/rails/v4.0.2/ActionDispatch/Routing/RouteSet/draw
  Rails.application.routes.disable_clear_and_finalize = true

  # Create a new route for our new action
  Rails.application.routes.draw do
    get 'test' => 'shiny_themes/test#test'
  end

  class RendersThemeTest < ActionController::TestCase
    tests TestController

    def setup
      @original_theme = @controller.class.theme
    end

    def teardown
      @controller.class.theme = @original_theme
    end

    test 'included controller has theme class attribute' do
      assert_includes(@controller.class.class_variables, :@@theme)
      assert_respond_to(@controller, :theme)
      assert_kind_of(ShinyThemes::Theme, @controller.class.theme)
    end

    test 'theme is created from config file' do
      theme_config = YAML.load_file(Rails.root.join('config', 'theme.yml'))[Rails.env]
      assert_equal(@controller.class.theme.name, theme_config['name'])
      assert_equal(@controller.class.theme.layout, theme_config['layout'])
    end

    test 'uses layout from controller theme' do
      get :test
      assert_template(layout: @controller.class.theme.layout)
    end

    test 'prepends template views to controller view paths' do
      get :test
      assert_includes(@controller.view_paths.paths.map(&:to_s), @controller.class.theme.views_path.to_s)
    end

    test '#renders_theme changes controller theme and layout' do
      test_theme_name, test_theme_layout = 'temp_theme', 'temp_layout'
      @controller.class_eval do
        renders_theme test_theme_name, layout: test_theme_layout
      end
      assert_equal(test_theme_name, @controller.class.theme.name)
      assert_equal(test_theme_layout, @controller.class.theme.layout)
    end
  end
end