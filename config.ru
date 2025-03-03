require 'newrelic_rpm'
require 'rack/contrib/try_static'
require 'rack/rewrite'
require 'dotenv'
require 'rack/ssl-enforcer'
require 'rack/xframe-options'
require 'rack-host-redirect'

Dotenv.load
require 'dotenv'

def load_404
  not_found_page = File.expand_path('../__public__/404.html', __FILE__)
  File.read(not_found_page)
end

if ENV['RACK_ENV'] == 'development'
  def not_found_html
    load_404
  end
else
  use Rack::SslEnforcer,
      :hsts => { :expires => 500, :subdomains => false },
      :strict => true

  not_found_html = load_404
end

use Rack::XFrameOptions, 'DENY'

# Determine if the C preview docs are enabled
docs_config = YAML.load_file('source/_data/docs.yaml')
preview_docs = docs_config.key?('c_preview')

use Rack::Rewrite do
  # Redirect all old PebbleKit docs to their new location
  r301      %r{/docs/js/(.*)},    '/docs/pebblekit-js/$1'
  # Redirect C preview docs to main C docs if there are no preview docs
  r302      %r{/docs/c/preview/?(.*)},    '/docs/c/$1' unless preview_docs
end

use Rack::HostRedirect, {
  'developer.rebble.io' => 'developer.rebble.io'
}

use Rack::TryStatic,
    root: '__public__',
    urls: %w(/),
    try: %w(.html index.html /index.html)

run lambda{ |_env|
  [404, { 'Content-Type'  => 'text/html' }, [not_found_html]]
}
