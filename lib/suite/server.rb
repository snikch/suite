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
      elsif path =~ /apple-touch-icon|favicon/
        respond_with_icon path
      else
        respond_with_content path
      end
    end

    def respond_with_asset path
      asset = Suite.project.asset path.gsub(/^\/assets\//,'')
      return not_found unless asset
      [
        200,
        headers,
        asset.body
      ]
    end

    def respond_with_icon path
      asset = Suite.project.asset path.gsub(/^\//,'')
      return not_found unless asset
      content_types = MIME::Types.type_for(path)
      headers = {'content-type'=> content_types.first.content_type } unless content_types.size == 0
      [
        200,
        headers,
        asset.body
      ]
    end

    def respond_with_content path
      return not_found unless page = Suite.project.page_at_slugs(slugs)
      renderer = Suite::Renderers::Page.new page[:layout], page[:content]
      [200,{},renderer.render]
    end

    private

    def headers
      headers = {}
      begin
        content_types = MIME::Types.type_for(env["REQUEST_PATH"])
        headers.merge!('content-type'=> content_types.first.content_type ) unless content_types.size == 0
        # Add caching headers for images
        headers.merge!(
          "Pragma" => "private",
          "Cache-Control" => "public, max-age: 3600",
          "Expires" => CGI.rfc1123_date(Time.now + (5*60))
        ) if env["REQUEST_PATH"] =~ /(jpg|jpeg|png|gif)$/

        headers
      rescue
        headers
      end
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
