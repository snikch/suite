require 'suite/project'
require 'suite/environment'
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

    def env= env
      @@env = env
    end

    def env
      @@env ||= Suite::Environment.new(ENV["SUITE_ENV"] || :development)
    end

    def use_project_at_path path, view = :desktop
      self.project = Suite::Project.new \
        path,
        YAML.load(File.open(path + "/config/suite.yml")),
        YAML.load(File.open(path + "/config/content.yml")),
        view
    end
  end
end
