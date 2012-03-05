# encoding: utf-8
require 'thor/group'
module Suite
  module Generators
    class Project < Thor::Group
      include Thor::Actions
      argument :name, type: :string

      def create_config
        say "I’m going to ask you some questions to create your config file"
        say "You can change these values in your config/suite.yml file"
        @compress_javascript = yes? "Compress JavaScript? [Yn]", :blue
        @shorten_javascript_variables = yes? "Shorten JavaScript Variables? [Yn]", :blue
        @compress_stylesheet = yes? "Compress CSS? [Yn]", :blue
        @using_cdn = yes? "Will you serve assets from a CDN?", :blue
        if @using_cdn
          @asset_host = ask("CDN Host and path [e.g. http://ak43nam.cloudfront.net/new_site]", :blue).gsub(/\/$/,'')
        end
      end

      def create_directory_structure
        empty_directory
        empty_directory "build"
        empty_directory "config"
        empty_directory "content"
        empty_directory "assets"
        empty_directory "assets/javascripts"
        empty_directory "assets/stylesheets"
      end

      def copy_files
        template "application.js.erb", "#{name}/assets/javascripts/application.js"
        template "application.scss.erb", "#{name}/assets/stylesheets/#{name}.css.scss"
        template "suite.yml.erb", "#{name}/config/suite.yml"
        template "content.yml", "#{name}/config/content.yml"
      end

      private

      def self.source_root
        File.dirname(__FILE__) + "/project"
      end

      def empty_directory folder_name = nil
        super "#{name}/#{folder_name}"
      end
    end
  end
end
