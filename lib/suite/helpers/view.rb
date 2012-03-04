
module Suite
  module Helpers
    module View
      def contents_for location, content = nil
        buffer = with_output_buffer { yield location}
        raise buffer.inspect
        @deferred_content[location] = "" unless @deferred_content[location]
        @deferred_content[location] += content if content
      end

      def javascript_include_tag path
        Suite.env.development? ? javascript_include_tags_for_asset(path) : raise("Implement javascript_include_tag for build phase")
      end

      def javascript_include_tags_for_asset path
        path = path + ".js" unless path =~ /\.js/
        assets = Suite.project.asset path
        assets.to_a.map do |asset|
          "<script type=\"text/javascript\" src=\"#{clean_asset_path asset.pathname.to_s}\"></script>"
        end.join("\n")
      end

      def clean_asset_path path
        path.sub(/\.coffee/,'').sub(Suite.project.path,'')
      end
    end
  end
end
