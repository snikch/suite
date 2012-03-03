module Suite
  class Project
    attr_accessor :path, :name, :config
    def initialize path, name, config
      @path, @name, @config = path, name, config
    end
  end
end

