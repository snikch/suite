require 'suite/helpers/view'

module Suite::Renderers
  class Abstract
    include Suite::Helpers::View

    def self.render_file path, deferred_content = {}, &block
      new(IO.read(path), deferred_content).render &block
    end

    def self.render content
      new(content).render
    end

    attr_accessor :content
    def initialize content, deferred_content
      @content, @deferred_content = content, deferred_content
    end

  end
end
