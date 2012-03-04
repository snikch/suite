module Suite
  module Helpers
    module View
      def contents_for location, content = nil
        buffer = with_output_buffer { yield location}
        raise buffer.inspect
        @deferred_content[location] = "" unless @deferred_content[location]
        @deferred_content[location] += content if content
      end

      # TODO Render individual script tags for 'require' calls
      def javascript_include_tag path
        path = path + ".js" unless path =~ /\.js/
        path = "/assets/javascripts/" + path unless path =~ /javascripts/
        "<script type=\"text/javascript\" src=\"#{path}\"></script>"
      end
    end
  end
end
