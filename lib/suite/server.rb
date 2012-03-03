require 'goliath/api'
require 'goliath/runner'
require 'suite/server/asset'
require 'suite/server/root_asset'
require 'suite/server/content'

module Suite
  class Server < Goliath::API
    map "/assets/*asset", Suite::AssetServer
    map "/*content", Suite::ContentServer

    %w[favicon.ico].each do |resource|
      map "/#{resource}", Suite::RootAssetServer
    end
  end
end
