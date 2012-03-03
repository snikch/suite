require 'goliath/api'
require 'goliath/runner'

module Suite
  class Server < Goliath::API
    map "/assets/*asset", Suite::Server::Assets
    map "/*content", Suite::Server::Content
  end
end
