namespace :custom_sync do
  def remote_to_local(cap)
    servers = Capistrano::Configuration.env.send(:servers)
    server = servers.detect { |s| s.roles.include?(:app) }
    port = server.netssh_options[:port] || 22
    user = server.netssh_options[:user]
    [cap.fetch(:assets_dir)].flatten.each do |dir|
      system("rsync -a --del -L -K -vv --progress --rsh='ssh -p #{port}' #{user}@#{server}:#{cap.current_path}/#{dir} #{cap.fetch(:local_assets_dir)}")
    end
  end

  def local_to_remote(cap)
    servers = Capistrano::Configuration.env.send(:servers)
    server = servers.detect { |s| s.roles.include?(:app) }
    port = server.netssh_options[:port] || 22
    user = server.netssh_options[:user]
    [cap.fetch(:assets_dir)].flatten.each do |dir|
      system("rsync -a --del -L -K -vv --progress --rsh='ssh -p #{port}' ./#{dir} #{user}@#{server}:#{cap.current_path}/#{cap.fetch(:local_assets_dir)}")
    end
  end

  def to_string(cap)
    [cap.fetch(:assets_dir)].flatten.join(" ")
  end

  namespace :remote do
    desc 'Synchronize your remote assets using local assets'
    task :sync do
      on roles(:app) do
        puts "Assets directories: #{fetch(:assets_dir)}"
        if fetch(:skip_data_sync_confirm) || Util.prompt("Are you sure you want to erase your server assets with local assets")
          local_to_remote(self)
        end
      end
    end
  end

  namespace :local do
    desc 'Synchronize your local assets using remote assets'
    task :sync do
      on roles(:app) do
        puts "Assets directories: #{fetch(:local_assets_dir)}"
        if fetch(:skip_data_sync_confirm) || Util.prompt("Are you sure you want to erase your local assets with server assets")
          remote_to_local(self)
        end
      end
    end
  end
end