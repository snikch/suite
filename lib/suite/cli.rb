require 'suite/environment'
require 'thor'
require "sprockets-sass"
require 'compass'

module Suite
  class CLI < Thor
    include Thor::Actions

    desc "project NAME", "Generates a project scaffold"
    def project name
      require 'suite/generators/project'
      Suite::Generators::Project.start([name])
    end

    desc "build TYPE", "Compiles a static version of your project. View type defaults to :desktop"
    def build view = :desktop
      say "Build must be run in a suite project directory", :red and return unless in_project_directory?
      Suite.use_project_at_path destination_root, view
      Suite.env = Suite::Environment.new :build

      require 'suite/builder'
      Suite::Builder.start([view])
    end

    desc "server", "Runs the suite development server"
    method_option :host, :type => :string, :default => "0.0.0.0",
    :aliases => "-a", :desc => "Host address"
    def server view = :desktop
      say "Server must be run in a suite project directory", :red and return unless in_project_directory?

      Suite.use_project_at_path destination_root, view
      begin
        require 'suite/server'
        Suite.env = Suite::Environment.new :development
        runner = Goliath::Runner.new(ARGV, nil)
        runner.log_stdout = true
        runner.api = Suite::Server.new
        runner.app = Goliath::Rack::Builder.build(Suite::Server, runner.api)
        runner.run
      rescue RuntimeError => e
        say "Could not start development server", :red
        say "\t#{e.message}", :yellow
      end
    end

    private

    def in_project_directory?
      File.exists?(destination_root + "/config/suite.yml")
    end

  end
end
