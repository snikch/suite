require 'thor/group'
module Suite
  module Generators
    class Project < Thor::Group
      include Thor::Actions
      argument :name, type: :string

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
        template "suite.yml", "#{name}/config/suite.yml"
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
