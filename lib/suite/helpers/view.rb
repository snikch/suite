require 'suite/project/asset_registry'

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
        path = path + ".js" unless path =~ /\.js/
        if Suite.env.development?
          javascript_include_tags_for_asset(path)
        else
          javascript_script_tag "#{Suite.project.asset_path}/javascripts/#{Suite.project.asset_registry.add_asset :js, path}.js"
        end
      end

      def javascript_include_tags_for_asset path
        assets = Suite.project.asset path
        assets.to_a.map do |asset|
          javascript_script_tag clean_asset_path asset.pathname.to_s
        end.join("\n")
      end

      def clean_asset_path path
        path.sub(/\.coffee/,'').sub(Suite.project.path,'')
      end

      def javascript_script_tag path
        "<script type=\"text/javascript\" src=\"#{path}\"></script>"
      end
    end
  end
end
