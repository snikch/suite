module Suite::Helpers
  module ImageViewHelper
    def image_tag src, attributes = {}
      attrs = []
      attributes.each_pair do |k,v|
        final_value = v.is_a?(Array) ? v.join(" ") : v
        final_value = ERB::Util.html_escape(final_value)
        attrs << %(#{k}="#{final_value}")
      end

      "<img src=\"#{Suite.project.asset_path}/images/#{ERB::Util.html_escape src}\" #{attrs.sort * ' '} />"
    end
  end
end
