require 'digest/md5'
module Suite
  class AssetRegistry

    attr_accessor :assets

    def initialize
      @assets = { js: {}, css: {} }
    end

    def add_asset type, path
      @assets[type][path] = Suite::Asset.new(path, type) unless @assets[type][path]
      @assets[type][path].identifier
    end

    def js
      @assets[:js]
    end

    def css
      @assets[:css]
    end

  end
  class Asset
    attr_accessor :path, :type
    def initialize path, type
      @path, @type = path, type
    end

    def identifier
      Digest::MD5.hexdigest to_s
    end

    def build_file_name
      "#{identifier}.#{type.downcase}"
    end

    def to_s
      @_memoized_to_s ||= compress Suite.project.asset(@path).to_s
    end

    def compress content
       case type
       when :js
         if Suite.project.config["compression"]["compress_javascript"]
           YUI::JavaScriptCompressor.new(:munge => Suite.project.config["compression"]["shorten_javascript_variables"]).compress content
         else
           content
         end
       when :css
         if Suite.project.config["compression"]["compress_css"]
           YUI::CssCompressor.new.compress content
         else
           content
         end
       else
         raise "Could not find YUI compressor for '#{type}'"
       end
    end
  end
end
