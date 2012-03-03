require 'suite/helpers/path'
require 'suite/server/error'
module Suite
  class AssetServer < Goliath::API
    include Suite::ServerError
    include Suite::Helpers::Path
    def response(env)
      file = project_path + "/assets/" + env.params[:asset].join("/")
      [200, {}, file]
    end
  end
end
