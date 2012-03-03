require 'suite/renderers/abstract'

module Suite::Renderers
  class HTML < Abstract

    def render
      @content
    end

  end
end
