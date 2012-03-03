require "suite/core"
require "suite/version"
require "suite/cli"

module Suite
  include Suite::Core
  class << self
    def project_path= name
      @@project_path = name
    end

    def project_path
      @@project_path
    end
  end
end
