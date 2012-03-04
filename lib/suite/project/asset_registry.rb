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
      Digest::MD5.hexdigest Suite.project.asset(@path).to_s
    end
  end
end
