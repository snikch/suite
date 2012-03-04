require 'suite/server/error'
require 'mime/types'
require "sprockets-sass"
require 'compass'

module Suite
  class AssetServer < Goliath::API
    include Suite::ServerError
    def response(env)
      asset = Suite.project.asset env.params[:asset].join("/")
      return not_found unless asset
      [
        200,
        {'content-type'=> MIME::Types.type_for(env.params[:asset].last).first.content_type },
        asset.body
      ]
    end
  end
end
