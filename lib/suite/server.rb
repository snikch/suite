require 'goliath/api'
require 'goliath/runner'
require 'suite/server/error'

module Suite
  class Server < Goliath::API
    include Suite::ServerError
    def response(env)
      path =  env["REQUEST_PATH"]
      if path =~ /^\/assets/
        respond_with_asset path
      else
        respond_with_content path
      end
    end

    def respond_with_asset path
      if path =~ /^\/assets\/images/
        output = respond_with_static_asset path
      else
        output = respond_with_dynamic_asset path
      end
    end

    def respond_with_static_asset path
      path = Suite.project.path + path
      return not_found unless File.exists? path
      [
        200,
        {'content-type'=> MIME::Types.type_for(path).first.content_type },
        IO.read(path)
      ]
    end

    def respond_with_dynamic_asset path
      asset = Suite.project.asset path.gsub(/^\/assets\//,'')
      return not_found unless asset
      [
        200,
        {'content-type'=> MIME::Types.type_for(path).first.content_type },
        asset.body
      ]
    end

    def respond_with_content path
      return not_found unless page = Suite.project.page_at_slugs(slugs)
      renderer = Suite::Renderers::Page.new page[:layout], page[:content]
      [200,{},renderer.render]
    end

    def slugs
      if self.env["REQUEST_PATH"] == "/"
        ["index"]
      else
        self.env["REQUEST_PATH"].split("/")
      end
    end

  end
end
