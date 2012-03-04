require 'suite/renderers/abstract'
require 'haml'
require 'action_view'

module Suite::Renderers
  class HAML < Abstract

    def render &block
      base = ActionView::Base.new(nil, {})
      base.output_buffer = ActionView::OutputBuffer.new
      #base.render type: :haml, inline: @content
      raise (Haml::Engine.new(@content).render base, &block).inspect
    end

  end
end
