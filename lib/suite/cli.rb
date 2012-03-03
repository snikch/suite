require 'thor'

module Suite
  class CLI < Thor
    include Thor::Actions

    desc "project NAME", "Generates a project scaffold"
    def project(name)
      require 'suite/generators/project'
      Suite::Generators::Project.start([name])
    end

    desc "server", "Runs the suite development server"
    def server
      assert_in_project_directory
      require 'suite/server'
      runner = Goliath::Runner.new(ARGV, nil)
      runner.log_stdout = true
      runner.api = Suite::Server.new
      runner.app = Goliath::Rack::Builder.build(Suite::Server, runner.api)
      runner.run
    end

    private

    def assert_in_project_directory
      raise "Run in a valid Suite project directory" unless File.exists?(destination_root + "/config/suite.yml")
    end

  end
end
