require 'goliath/api'
require 'goliath/runner'
require 'suite/server/error'
require 'suite/renderers/page'
require 'mime/types'

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
