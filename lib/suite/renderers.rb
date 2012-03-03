module Suite
  module Renderers
    class << self
      def default_renderers
        {
          haml: Suite::Renderers::HAML
        }
      end
    end
  end
end
