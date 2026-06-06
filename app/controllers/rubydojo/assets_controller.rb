module Rubydojo
  class AssetsController < ApplicationController
    def css
      css_path = Rubydojo::Engine.root.join("app/assets/stylesheets/rubydojo/application.css")
      send_file css_path, type: "text/css", disposition: "inline"
    end
  end
end
