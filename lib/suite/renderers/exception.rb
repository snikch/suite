module Suite
  module Renderers
    class Exception
      attr_accessor :message
      def initialize message
        @message = message
        if Suite.env.build?
          raise message.gsub(/<([^>]*)>/,'"')
        end
      end

      def to_s
        "<div style='position:fixed; top:0; width: 100%; font-family: sans-serif; text-align:center; font-size:24px; padding:25px; background-color:#FFF3C2;'>#{message}</div>"
      end
    end
  end
end
