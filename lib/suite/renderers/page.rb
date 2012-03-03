require 'suite/renderers/haml'
require 'suite/renderers/html'

module Suite::Renderers
  class Page
    attr_accessor :partials
    def initialize partials
      @partials = partials
    end

    def render
      partials.map do |partial|
        render_partial partial
      end.join("\n")
    end

    def render_partial partial
      root = Suite.project.path + "/content/" + partial
      output = nil
      Suite.project.file_types.each do |file_type|
        Suite.project.renderers.each do |extension, renderer|
          path = root + "." + file_type.to_s + "." + extension.to_s
          if File.exists?(path)
            output = renderer.render_file(path)
            break
          end
        end
        break if output
        path = root + ".html"
        if File.exists?(path)
          output = Suite::Renderers::HTML.render_file(path)
          break
        end
      end
      output ? output : missing_partial(partial)
    end

    def missing_partial partial
      "<!-- Could not find partial '#{partial}'"
    end
  end
end
