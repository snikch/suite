require 'suite/project/asset_registry'
require 'suite/helpers/image_view_helper'
require 'suite/helpers/javascript_view_helper'
require 'suite/helpers/stylesheet_view_helper'

module Suite
  module Helpers
    module ViewHelpers
      include ImageViewHelper
      include JavascriptViewHelper
      include StylesheetViewHelper

      def clean_asset_path path
        path.sub(/\.coffee|\.scss|\.sass/,'').sub(Suite.project.path,'')
      end

    end
  end
end
