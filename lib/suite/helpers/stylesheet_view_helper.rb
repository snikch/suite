module Suite::Helpers
  module StylesheetViewHelper

    def stylesheet_link_tag path, media = :all
      path = path + ".css" unless path =~ /\.css/
      if Suite.env.build?
        path = Suite.project.asset_registry.add_asset(:css, path) + ".css"
      end
      "<link rel=\"stylesheet\" href=\"#{Suite.project.asset_path}/stylesheets/#{path}\" media=\"#{media}\" />"
    end

  end
end
