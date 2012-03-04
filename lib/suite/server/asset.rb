require 'suite/server/error'
require 'mime/types'

module Suite
  class AssetServer < Goliath::API
    include Suite::ServerError
    def response(env)
      asset = Suite.project.asset env.params[:asset].join("/")
      return not_found unless asset
      [
        200,
        {'content-type'=> MIME::Types.type_for(asset.pathname.to_s).first.content_type },
        asset.to_s
      ]
    end
  end
end
