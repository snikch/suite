require 'digest/md5'
require 'thor/group'
require 'suite/renderers/page'

module Suite
  class Builder < Thor::Group
    include Thor::Actions
    argument :type, type: :string

    def render
      create_directory_structure
      render_content
      render_assets
    rescue => e
      say_status :error, e.message, :red
      say_status :cancelling, "Deleting built files and folders", :yellow
      run "rm -rf #{build_directory}"
      raise e
    end

    private

    def render_content
      render_content_array Suite.project.content["pages"]
    end

    def render_assets
      { js: :javascripts, css: :stylesheets }.each do |type, folder|
        Suite.project.asset_registry.send(type).each do |path, asset|
          out_path = "#{build_directory}/#{asset_directory}/#{folder}/#{asset.build_file_name}"
          if File.exists?(out_path)
            say_status :unchanged, "#{path} as #{asset.build_file_name}", :black
          else
            File.open(out_path, 'w') do |f|
              f.write Suite.project.asset(path).to_s
            end
            say_status :create, "#{path} as #{asset.build_file_name}", :green
          end
        end
      end
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
      empty_directory("#{cdn_directory}/#{folder_name}")
    end

    def cdn_directory
      "cdn"
    end

    def empty_asset_directory folder_name = nil
      empty_directory "#{asset_directory}/#{folder_name}"
    end

    def asset_directory
      using_cdn? ? cdn_directory : site_directory + "/assets"
    end

    def render_content_array array, folder = nil
      array.each do |name, page|
        if page["content"]
          render_to_file \
            folder,
            "#{name}.html",
            page["content"],
            page["layout"] || Suite.project.content["layout"]
        end
        page.delete "content"
        render_content_array page, "#{folder}/#{name}" if page.size > 0
      end
    end

    def render_to_file folder, file, contents, layout
      renderer = Suite::Renderers::Page.new layout, contents
      empty_site_directory folder if folder
      out_path = build_directory + "/" + site_directory + (folder ? "/" + folder : "") + "/" + file
      out_content = renderer.render
      if File.exists? out_path
        if file_hash(out_path) != content_hash(out_content)
          write_file out_path, out_content
          say_status :update, "#{folder}/#{file}", :yellow
        else
          say_status :unchanged, "#{folder}/#{file}", :black
        end
      else
        write_file out_path, out_content
        say_status :create, "#{folder}/#{file}"
      end
    end

    def write_file path, content
      File.open(path, 'w'){ |f| f.write content }
    end

    def file_hash path
      content_hash IO.read path
    end

    def content_hash content
      Digest::MD5.hexdigest content
    end
  end
end

