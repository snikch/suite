require 'suite/renderers/abstract'
require 'haml'

module Suite::Renderers
  class HAML < Abstract

    def render &block
      Haml::Engine.new(@content).render(self, &block)
    end

  end
end
