# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '107.170.92.134', user: 'webadmin', roles: %w{web app db}

set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}

# Global options
# --------------
set :ssh_options, {
  forward_agent: true
}

# set :rails_env, 'staging'                  # If the environment differs from the stage name
# set :migration_role, 'migrator'            # Defaults to 'db'
# set :conditionally_migrate, true           # Defaults to false. If true, it's skip migration if files in db/migrate not modified
# set :assets_roles, [:web, :app]            # Defaults to [:web]
# set :assets_prefix, 'prepackaged-assets'   # Defaults to 'assets' this should match config.assets.prefix in your rails config/application.rb