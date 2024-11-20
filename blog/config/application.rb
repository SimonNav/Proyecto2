require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Blog
  class Application < Rails::Application
    config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.load_defaults 7.1


    config.autoload_lib(ignore: %w(assets tasks))

   
  end
end
