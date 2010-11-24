#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['solo','app_master','app'].include?(node[:instance_role])
  %w(cocodot publisher).each do |app_name|
    env_dir = "/data/#{app_name}/shared/config"
    worker_processes = app_name == 'cocodot' ? 3 : 2
     
    template "#{env_dir}/unicorn_custom.rb" do
      owner node[:owner_name]
      group node[:owner_name]
      source 'unicorn_config.rb.erb'
      variables({
        :worker_processes => worker_processes
      })
    end
    
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
