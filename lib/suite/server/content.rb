require 'suite/server/error'

module Suite
  class ContentServer < Goliath::API
    include Suite::ServerError
    def response env
      return not_found unless Suite.project.include? slugs
      [200,{},"blarg"]
    end

    # Returns the array of slugs, or index if no slug
    def slugs
      self.env.params[:content].map{ |slug| slug == "" ? "index" : slug }
    end
  end
end
