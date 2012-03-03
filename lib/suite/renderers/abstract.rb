module Suite::Renderers
  class Abstract

    def self.render_file path
      new(IO.read path).render
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
