require 'suite/helpers/view'

module Suite::Renderers
  class Abstract
    include Suite::Helpers::View

    def self.render_file path, &block
      new(IO.read path).render &block
    end

    def self.render content
      new(content).render
    end

    attr_accessor :content
    def initialize content
      @content = content
    end

  end
end
