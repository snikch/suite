require 'suite/server/error'
require 'suite/renderers/page'

module Suite
  class ContentServer < Goliath::API
    include Suite::ServerError
    def response env
      return not_found unless page = Suite.project.page_at_slugs(slugs)
      renderer = Suite::Renderers::Page.new page[:layout], page[:content]
      [200,{},renderer.render]
    end

    # Returns the array of slugs, or index if no slug
    def slugs
      self.env.params[:content].map{ |slug| slug == "" ? "index" : slug }
    end
  end
end
