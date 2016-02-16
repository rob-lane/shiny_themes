require 'rails/generators'

module ShinyThemes
  module Generators
    class ThemeGenerator < Rails::Generators::NamedBase
      desc            "This generator creates a new theme using the provided name and options"
      source_root     File.expand_path("../templates", __FILE__)
      argument        :name, type: :string
      class_option   :layout, type: :string, aliases: '-l', default: 'application', desc: 'Default layout for theme rendering'
      class_option   :sass, type: :boolean, aliasses: '-s', default: false, desc: 'Use sass for stylesheets'

      def initialize(args, *options)
        super
        @theme_directory = Pathname(Rails.application.config.theme.path).join(name)
        @views_directory = @theme_directory.join('views')
        @assets_directory = @theme_directory.join('assets')
      end

      def create_theme_directories
        # Create views directories
        empty_directory @views_directory.join('layouts')
        # Create Assets directories
        empty_directory @assets_directory.join('images', name)
        create_file     @assets_directory.join('images', name, '.gitkeep'), nil
        empty_directory @assets_directory.join('javascripts', name)
        create_file     @assets_directory.join('javascripts', name, '.gitkeep'), nil
        empty_directory @assets_directory.join('stylesheets', name)
        create_file     @assets_directory.join('stylesheets', name, '.gitkeep'), nil
      end

      def create_js_files
        copy_file 'manifest.js', "#{@assets_directory.join('javascripts', name, 'manifest.js')}"
      end

      def create_css_files
        return if options[:sass]
        copy_file 'manifest.css', "#{@assets_directory.join('stylesheets', name, 'manifest.css')}"
      end

      def create_sass_files
        return unless options[:sass]
        copy_file 'manifest.scss', "#{@assets_directory.join('stylesheets', name, 'manifest.scss')}"
      end

      def create_layout_file
        copy_file 'application.html.erb', "#{@views_directory.join('layouts', "#{options[:layout]}.html.erb")}"
      end
    end
  end
end