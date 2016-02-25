module ShinyThemes
  module RendersTheme
    extend ActiveSupport::Concern
    included do
      cattr_accessor :theme
      self.theme = Theme.new
      layout Proc.new { |controller| controller.class.theme.layout }
      prepend_before_action do |controller|
        controller.prepend_view_path controller.class.theme.views_path
      end
    end

    def current_theme_name
      self.class.theme.name
    end

    def update_current_theme(name, options = {})
      self.class.renders_theme(name, options)
      Rails.application.config.theme.name = current_theme_name
      Rails.application.config.theme.layout = self.class.theme.layout
      ShinyThemes::Engine.theme_config.save unless options[:dont_save]
      self.class.theme # return current theme object
    end

    module ClassMethods
      def renders_theme(theme_name, options = {})
        self.theme = Theme.new(options.merge(name: theme_name, layout: options[:layout]))
      end
    end
  end
end