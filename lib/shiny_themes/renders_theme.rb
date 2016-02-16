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

    module ClassMethods
      def renders_theme(theme_name, options = {})
        self.theme = Theme.new(options.merge(name: theme_name, layout: options[:layout]))
      end
    end
  end
end