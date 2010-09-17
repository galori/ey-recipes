#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['solo','app_master','app'].include?(node[:instance_role])
  execute "sh -c 'sed -e \"s/^worker_processes.*$/worker_processes 2/\" /data/publisher/shared/config/unicorn.rb > /data/publisher/shared/config/unicorn_custom.rb'"
  execute "sh -c 'sed -e \"s/^worker_processes.*$/worker_processes 3/\" /data/cocodot/shared/config/unicorn.rb > /data/cocodot/shared/config/unicorn_custom.rb'"
  
  template '/data/cocodot/shared/config/env.custom' do
    owner node[:owner_name]
    group node[:owner_name]
    source 'env.custom.erb'
  end
end
