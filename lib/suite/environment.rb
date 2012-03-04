module Suite
  class Environment

    attr_accessor :env

    def initialize env
      @env = env.to_sym
    end

    def == val
      @env == val.to_sym
    end

    def development?
      @env == :development
    end

    def build?
      @env == :build
    end
  end
end
