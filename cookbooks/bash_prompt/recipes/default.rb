#
# Cookbook Name:: rails_env_bash_prompt
# Recipe:: default
#
user = node[:users].first

template "/home/#{user[:username]}/.bashrc" do
  source 'bashrc.erb'
  owner   user[:username]
  group   user[:username]
  mode    0644
  backup  2
  variables({
    :environment_name => node[:environment][:name],
    :instance_role => node[:instance_role]
  })
end

