require 'thor/group'
require 'suite/renderers/page'

module Suite
  class Builder < Thor::Group
    include Thor::Actions
    argument :type, type: :string

    def render
      run "rm -rf #{build_directory}"
      create_directory_structure
      render_files
    rescue => e
      say_status :error, e.message, :red
      say_status :cancelling, "Deleting built files and folders", :yellow
      run "rm -rf #{build_directory}"
      raise e
    end

    private

    def render_files
      render_array Suite.project.content["pages"]
    end

    def create_directory_structure
      Suite.project.content
      empty_directory
      if using_cdn?
        empty_site_directory
        empty_cdn_directory
      end
      empty_asset_directory
      empty_asset_directory "javascripts"
      empty_asset_directory "stylesheets"
      empty_asset_directory "images"
    end

    def using_cdn?
      !!Suite.project.config["cdn_host"]
    end

    def empty_directory folder_name = nil
      super "#{build_directory}/#{folder_name}"
    end

    def build_directory
      "build/#{type}"
    end

    def empty_site_directory folder_name = nil
      empty_directory "#{site_directory}/#{folder_name}"
    end

    def site_directory
      using_cdn? ? "site" : ""
    end

    def empty_cdn_directory folder_name = nil
      empty_directory("cdn/" + folder_name)
    end

    def empty_asset_directory folder_name = nil
      folder_name = "assets/#{folder_name}"
      using_cdn? ? empty_cdn_directory(folder_name) : empty_site_directory(folder_name)
    end

    def render_array array, folder = nil
      array.each do |name, page|
        if page["content"]
          render_to_file \
            folder,
            "#{name}.html",
            page["content"],
            page["layout"] || Suite.project.content["layout"]
        end
        page.delete "content"
        render_array page, "#{folder}/#{name}" if page.size > 0
      end
    end

    def render_to_file folder, file, contents, layout
      renderer = Suite::Renderers::Page.new layout, contents
      empty_site_directory folder if folder
      File.open(
        build_directory + "/" + site_directory + (folder ? "/" + folder : "") + "/" + file, 'w'
      ) do |f|
        f.write renderer.render
      end
      say_status :create, "#{folder}/#{file}"
    end
  end
end

