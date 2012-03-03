require 'thor'

module Suite
  class CLI < Thor
    desc "project NAME", "Generates a project scaffold"
    def project(name)
      require 'suite/generators/project'
      Suite::Generators::Project.start([name])
    end

    desc "server", "Runs the suite development server"
    def server
      require 'suite/server'
      runner = Goliath::Runner.new(ARGV, nil)
      runner.log_stdout = true
      runner.api = Suite::Server.new
      runner.app = Goliath::Rack::Builder.build(Suite::Server, runner.api)
      runner.run
    end
  end
end
