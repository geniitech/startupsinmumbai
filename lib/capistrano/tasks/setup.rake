########## Initialization tasks - single runs ##########
namespace :init do

  desc "Setup server with folder structures and permissions as well as apache conf"
  task :setup, :set_permissions, :create_vhost, :enable_site do
  end

  desc "Set proper permissions for the deploy user."
  task :set_permissions do
    on roles(:web) do |host|
      execute "sudo mkdir -p #{deploy_to}"
      execute "sudo chown webadmin:webadmin #{deploy_to}"
      execute "sudo chmod g+s #{deploy_to}"
      execute "sudo mkdir #{deploy_to}/{releases,shared}"
      execute "sudo chown webadmin #{deploy_to}/{releases,shared}"
    end
  end

  desc "Create the shared and secure database.yml on server"
  task :database_yml do
    on roles(:web) do |host|
      set :db_pass, ask('Server password', nil)
      set :db_user,  ask('Server user', nil)
      database_configuration = %(
      production:
        adapter: mysql2
        encoding: utf8
        database: #{fetch(:application)}_production
        host: localhost
        username: #{fetch(:db_user)}
        password: #{fetch(:db_pass)}
        socket: /var/run/mysqld/mysqld.sock
      )
      execute "mkdir -p #{shared_path}/config"
      contents = StringIO.new(database_configuration)
      upload! contents, "#{shared_path}/config/database.yml"
    end
  end

  desc "Enables the website in apache"
  task :enable_site do
    on roles(:web) do |host|
      execute "sudo ln -fs #{shared_path}/config/api.conf /etc/apache2/sites-enabled/api.conf"
    end
  end

  desc "Create the apache vhost file and save it in shared/config path."
  task :create_vhost do
    on roles(:web) do |host|
      vhost_configuration = %(
        <VirtualHost *:80>
          ServerName startupsinmumbai.com
          ServerAlias www.startupsinmumbai.com
          DocumentRoot #{release_path.join('public')}
          <Directory #{release_path.join('public')}>
             AllowOverride all
             Options -MultiViews
          </Directory>
          <LocationMatch "^/assets/.*$">
            Header unset ETag
            FileETag None
            ExpiresActive On
            ExpiresDefault "access plus 1 year"
          </LocationMatch>
        </VirtualHost>
      )
      contents = StringIO.new(vhost_configuration)
      upload! contents, "#{shared_path}/config/api.conf"
    end
  end
end
