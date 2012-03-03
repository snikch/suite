module Suite
  class Project
    attr_accessor :path, :view
    def initialize path, view
      @path, @view = path, view
    end

    def config
      @config ||= YAML.load(File.open(path + "/config/suite.yml"))
    end

    # Retrieves the content array for the current view
    def content
      unless @content
        @content = YAML.load(File.open(path + "/config/content.yml"))
      end
      @content[view.to_s]
    end

    def pages
      content["pages"]
    end

    def include? slugs
      content_level = pages
      slugs.each do |slug|
        return false unless content_level = content_level[slug.to_s]
      end
      return !!content_level["content"]
    end
  end
end

