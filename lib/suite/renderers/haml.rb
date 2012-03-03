require 'suite/renderers/abstract'
require 'haml'

module Suite::Renderers
  class HAML < Abstract

    def render
      Haml::Engine.new(@content).def_method(self, :render_haml)
      render_haml
    end

  end
end
