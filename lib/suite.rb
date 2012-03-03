require 'suite/project'
require "suite/version"
require "suite/cli"
require 'yaml'

module Suite
  class << self
    def project= project
      @@project = project
    end

    def project
      @@project
    end

    def use_project_at_path path
      self.project = Suite::Project.new \
        path,
        path.split('/').last,
        YAML.load(path + "/config/suite.yml")
    end
  end
end
