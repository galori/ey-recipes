#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['solo','app_master','app'].include?(node[:instance_role])
  execute "sh -c 'sed -e \"s/^worker_processes.*$/worker_processes 2/\" /data/publisher/shared/config/unicorn.rb > /data/publisher/shared/config/unicorn_custom.rb'"
  execute "sh -c 'sed -e \"s/^worker_processes.*$/worker_processes 3/\" /data/cocodot/shared/config/unicorn.rb > /data/cocodot/shared/config/unicorn_custom.rb'"
  
  ['/data/cocodot/shared/config','/data/publisher/shared/config'].each do |env_dir|
    template "#{env_dir}/env.custom" do
      owner node[:owner_name]
      group node[:owner_name]
      source 'env.custom.erb'
      variables({
        :unicorn_config_path => "#{env_dir}/unicorn_custom.rb"
      })
    end
  end
end
