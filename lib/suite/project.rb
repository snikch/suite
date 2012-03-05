require 'suite/renderers'
require 'sprockets'
module Suite
  class Project
    attr_accessor :path, :config, :content, :view
    def initialize path, config, content, view
      @path, @config, @content, @view = path, config, content, view
    end

    def config
      @config || {}
    end

    # Retrieves the content hash for the current view
    def content
      @content[view.to_s] || raise("No view '#{view}' defined")
    end

    def pages
      content["pages"]
    end

    def include? slugs
      return !!content_at_slugs(slugs)
    end

    def page_at_slugs slugs
      content_level = pages
      slugs.each do |slug|
        return false unless content_level = content_level[slug.to_s]
      end
      return {
        layout: content_level["layout"] ? content_level["layout"] : content["layout"],
        content: content_level["content"]
      }
    end

    def file_types
      config["file_types"] || [:html]
    end

    def asset path
      sprocket_environment[path.sub(/javascripts\/|stylesheets\//,'')]
    end

    def source_asset_path
      path + "/assets"
    end

    def asset_path
      config["asset_host"] ? config["asset_host"] : "/assets"
    end

    def asset_registry
      @_memoized_asset_registry ||= Suite::AssetRegistry.new
    end

    def sprocket_environment
      @_memorized_sprocket_environment ||= begin
        environment = Sprockets::Environment.new
        environment.append_path source_asset_path + '/javascripts'
        environment.append_path source_asset_path + '/stylesheets'
        environment
      end
    end

    # TODO: Puts a renderers config in the yaml to add new renderers
    def renderers
      @_memoized_render_types ||= begin
        Suite::Renderers.default_renderers
      end
    end
  end
end

