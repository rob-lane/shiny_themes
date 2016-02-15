module ShinyThemes
  # Theme model class which is meant to be associated with one or more
  # controllers.  This theme "contains" assets (css, js, etc) as well as any
  # views the them overrides and/or defines.
  class Theme
    include ActiveModel::Validations
    # @return [String] the name of the theme which must match the root directory
    #   name where theme files are located.  Defaults to config.theme.name value
    attr_reader :name
    # @return [String]] the name of the default layout to use.  Defaults to
    #   config.theme.layout or 'application' if this does not exist
    attr_reader :layout

    validates_presence_of :name, :layout
    # 'views' directory must exist in the theme directory 'name/views' where
    #   name is the theme name
    validate :views_directory_exists
    # 'assets' directory must exist in the theme directory 'name/assets' where
    #   name is the theme name
    validate :assets_directory_exists
    # all THEME_ASSET_DIRECTORIES must exist under 'name/assets' and must have a
    # namespaced directory that shares the name of the theme.  For example the
    # images directory should look like - 'name/assets/images/name' where name is
    # the theme name.

    validate do |theme|
      ShinyThemes::THEME_ASSET_DIRECTORIES.each do |directory|
        unless theme.asset_path.join(directory).exist? &&
            theme.asset_path.join(directory, name).exist?
          theme.errors.add(:base, "Missing or invalid #{directory} asset directory for theme")
        end
      end
    end

    # @param options [Hash] initialization options
    # @option options [String] :name (Rails.application.config.theme.name) The 1
    #   name of the theme.
    # @option options [String] :layout (Rails.application.config.theme.layout ||
    #   'application') The name of the default layout.
    # @option options [String] : :theme_path (DEFAULT_THEME_PATH) The path to the
    #   theme's parent directory.
    def initialize(options = {})
      @name = options[:name] || Rails.application.config.theme.name
      @layout = options[:layout] || Rails.application.config.theme.layout || 'application'
      @theme_path = options[:theme_path] || DEFAULT_THEME_PATH
    end

    # @return [Pathname] Path to the theme's root directory
    def path
      Rails.root.join(@theme_path, @name)
    end

    # @return [Pathname] Path to the theme's view directory
    def views_path
      path.join('views')
    end

    # @return [Pathname] Path to the theme's assets directory
    def asset_path
      path.join('assets')
    end

    protected

      def views_directory_exists
        unless views_path.exist? && views_path.directory?
          errors.add(:base, "Missing theme views directory")
        end
      end

      def assets_directory_exists
        unless asset_path.exist? && asset_path.directory?
          errors.add(:base, "Missing theme assets directory")
        end
      end
  end
end