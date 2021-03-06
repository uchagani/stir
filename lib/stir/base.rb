$LOAD_PATH << File.dirname(__FILE__)
require 'active_support/all'
require 'base/configuration'
require 'base/response'
require 'base/client'
require 'core_ext/string'

# Work around for ruby 2. The include method is not private in ruby 2.1+
String.send(:include, CoreExt::String)


module Stir
  class PathNotFoundError < StandardError; end

  class << self

    attr_accessor :path, :environment, :version

    def configure
      yield self
      load_clients
    end

    def configuration
      instance_values.symbolize_keys
    end

    private

    def load_clients
      validate_path_to("#{@path}/clients")
      Dir.glob("#{@path}/clients/**/*.rb") { |file| require file }
    end

    def validate_path_to(directory)
      raise(PathNotFoundError, "Invalid path for Stir clients: #{directory}") unless File.directory?(directory)
    end

  end
end