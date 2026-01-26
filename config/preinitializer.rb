# Compatibility patch for Rails 2.3.3 with Ruby 2.7 and modern RubyGems
# This file is loaded by config/boot.rb before Rails initializes

require 'rubygems'

# Use Syck YAML parser instead of Psych for Rails 2.3.3 compatibility
# Rails 2.3.3 YAML files were written for Syck and may not parse correctly with Psych
begin
  require 'yaml'
  YAML::ENGINE.yamler = 'syck' if defined?(YAML::ENGINE)
rescue
  # If syck is not available, we'll use Psych and hope for the best
  require 'yaml'
end

# Patch for YAML compatibility - yaml_as was removed in Ruby 2.1+
# Rails 2.3.3's ActiveSupport uses yaml_as
unless Class.respond_to?(:yaml_as)
  class Class
    def yaml_as(tag)
      # Modern Ruby uses yaml_tag instead
      # For Rails 2.3.3 compatibility, just make this a no-op
    end
  end
end

# Create a fake SourceIndex class for compatibility with Rails 2.3.3
# SourceIndex was removed in RubyGems 2.0+
unless defined?(Gem::SourceIndex)
  module Gem
    class SourceIndex
      include Enumerable

      attr_reader :specs

      def initialize(specs = {})
        @specs = specs
      end

      def self.from_installed_gems(*args)
        new
      end

      def self.from_gems_in(*args)
        new
      end

      def add_spec(spec)
        @specs[spec.full_name] = spec
      end

      def remove_spec(full_name)
        @specs.delete(full_name)
      end

      def each(&block)
        Gem::Specification.each(&block)
      end

      def search(dependency)
        # In modern RubyGems, find_all doesn't take arguments the same way
        # Convert dependency search to modern API
        if dependency.respond_to?(:name)
          Gem::Specification.find_all_by_name(dependency.name, dependency.requirement)
        else
          Gem::Specification.find_all
        end
      end

      def find_name(*args)
        Gem::Specification.find_all_by_name(*args)
      end

      def spec_dirs
        Gem::Specification.dirs
      end

      def refresh!
        # No-op for modern RubyGems
      end

      def load_gems_in(*args)
        # No-op for modern RubyGems
      end

      def specification(full_name)
        Gem::Specification.find_by_name(full_name.split('-').first)
      rescue Gem::LoadError
        nil
      end

      def index_signature
        # Return empty string for compatibility
        ""
      end
    end

    # Make sure Gem.source_index returns a SourceIndex instance
    def self.source_index
      @source_index ||= SourceIndex.new
    end

    def self.source_index=(index)
      @source_index = index
    end
  end
end

# Fix I18n YAML loading for Ruby 2.7
# The i18n library in Rails 2.3.3 doesn't recognize .yml files in Ruby 2.7
begin
  require 'i18n/backend/simple'

  module I18n
    module Backend
      class Simple
        # Patch to recognize .yml files
        alias_method :original_load_file, :load_file

        def load_file(filename)
          type = File.extname(filename).tr('.', '').downcase
          if type == 'yml'
            # Load YAML file directly
            data = YAML.load_file(filename)
            data.each { |locale, d| store_translations(locale, d || {}) }
          else
            original_load_file(filename)
          end
        end
      end
    end
  end
rescue LoadError
  # I18n not yet loaded, will be patched when it loads
end
