module ShinyThemes
  # RendersTheme concern
  # Included into ActionController::Base providing a theme class variable for controllers.
  # This theme defines a view path for templates and a layout to render with.
  module RendersTheme
    extend ActiveSupport::Concern

    included do
      cattr_accessor :theme
      # Create a new theme which will use Rails.application.config.theme settings
      self.theme = Theme.new
      layout Proc.new { |controller| controller.class.theme.layout }
      prepend_before_action do |controller|
        controller.prepend_view_path controller.class.theme.views_path
      end
    end

    # @return [String] the current theme name
    def current_theme_name
      self.class.theme.name
    end

    # @return [String] the current theme default layout
    def current_theme_layout
      self.class.theme.layout
    end

    # Update the current theme for the controller and optionally save
    # @param name [String] The name of the new theme
    # @param options [Hash] Options hash
    # @option options [String] :layout ('application') Default layout for theme
    # @option options [Boolean] :dont_save (false) Dont save the update to the theme.yml config
    # @return (Theme) the theme for the controller
    def update_current_theme(name, options = {})
      self.class.renders_theme(name, options)
      Rails.application.config.theme.name = current_theme_name
      Rails.application.config.theme.layout = current_theme_layout
      ShinyThemes::Engine.theme_config.save unless options[:dont_save]
      self.class.theme # return current theme object
    end

    module ClassMethods
      # Use the theme and options for all rendering in this controller
      # @param name [String] the name of the new theme
      # @param options [Hash] Options hash
      # option options [String] :layout ('application') Default layout for theme
      # @return (Theme) the theme for the controller
      def renders_theme(name, options = {})
        self.theme = Theme.new(options.merge(name: name, layout: options[:layout]))
      end
    end
  end
end