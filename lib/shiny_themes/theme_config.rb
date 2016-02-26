module ShinyThemes
  class ThemeConfig
    attr_accessor :defaults
    # Create the ordered options, populate with provided hash and load YAML file
    # options.
    # @param default_options [Hash] (Hash.new) - Options to populate the theme
    #   config with.
    # @options default_options [String] :path The path relative to the rails root
    #   where templates are installed
    # @options default_options [Array(String)] :asset_directories Names of
    #   directories containing assets for the theme relative to the 'assets'
    #   directory.
    def initialize(defaults = Engine.default_options)
      unless Rails.application.config.try(:theme)
        Rails.application.config.theme = ActiveSupport::OrderedOptions.new
      end
      @defaults = defaults
    end

    # Load the theme.yml file and merge it with the theme configuration
    def load
      new_config = full_config[Rails.env].deep_symbolize_keys!
      # Honor values in config file over defaults
      @defaults.reject! { |k, _| new_config.keys.include?(k) }
      Rails.application.config.theme.merge!(@defaults.merge(new_config))
    end

    # Save the current state of the theme config to the theme.yml file
    def save
      # Don't save default values
      save_config = Rails.application.config.theme.reject { |k, _| @defaults.keys.include?(k) }
      full_config[Rails.env].merge!(save_config)
      File.open(config_pathname, 'w') { |f| f << full_config.to_yaml }
    end

    # The pathname where the theme config file can be found
    def config_pathname
      Rails.root.join('config', 'theme.yml')
    end

    def full_config
      @full_config ||= YAML.load(File.open(config_pathname))
    end
  end
end