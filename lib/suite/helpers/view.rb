module Suite
  module Helpers
    module View
      def contents_for location, content = nil
        buffer = with_output_buffer { yield location}
        raise buffer.inspect
        @deferred_content[location] = "" unless @deferred_content[location]
        @deferred_content[location] += content if content
      end
    end
  end
end
