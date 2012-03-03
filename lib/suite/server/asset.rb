require 'suite/helpers/path'
require 'suite/server/error'
require 'mime/types'

module Suite
  class AssetServer < Goliath::API
    include Suite::ServerError
    include Suite::Helpers::Path
    def response(env)
      file = Suite.project_path + "/assets/" + env.params[:asset].join("/")
      return not_found unless File.exists? file


      [
        200,
        {'content-type'=> MIME::Types.type_for(file).first.content_type },
        File.read(file)
      ]
    end
  end
end
