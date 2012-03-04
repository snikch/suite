require 'suite/renderers/haml'
require 'suite/renderers/html'

module Suite::Renderers
  class Page

    attr_accessor :layout, :partials, :contents

    def initialize layout, partials
      @layout, @partials, @contents = layout, partials, {}
    end

    def render
      base = ActionView::Base.new(nil, {})
      base.output_buffer = ActionView::OutputBuffer.new
      #base.render type: :haml, inline: @content
      haml = Haml::Engine.new(IO.read layout_path)
      part = partials.map do |partial|
          Haml::Engine.new(IO.read(Suite.project.path + "/content/" + partial + ".html.haml")).render base
#          haml.render base, inline: IO.read(Suite.project.path + "/content/" + partial + ".html.haml")
      end.join("\n")
      out = haml.render base do
        part
      end
      return out





      render_layout(partials.map do |partial|
        render_partial partial
      end.join("\n"))
    end

    def render_layout body
      return body unless layout
      Suite::Renderers::HAML.render_file(layout_path) do |location|
        if location
          @contents[location]
        else
          body
        end
      end
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
          output = Suite::Renderers::HTML.render_file(path, @contents)
          break
        end
      end
      output ? output : missing_partial(partial)
    end

    def layout_path
      Suite.project.path + "/content/" + layout + ".html.haml"
    end

    def missing_partial partial
      "<!-- Could not find partial '#{partial}' -->"
    end

  end
end
