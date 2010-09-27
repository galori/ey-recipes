#
# Cookbook Name:: ey-data
# Recipe:: default
#

require 'etc'

if ['solo','app_master','app','util'].include?(node[:instance_role])
  ey_cloud_report "EYData" do
      message "Pulling Custom EY Config Data"
  end

  #Setup SSH for git
  template '/home/deploy/.ssh/config' do
    owner node[:owner_name]
    group node[:owner_name]
    source 'ssh_config.erb'
  end

  ey_data_dir = '/data/ey-data'

  ey_data_cmd = "sudo -u deploy sh -c 'rm -Rf #{ey_data_dir}; git clone --depth 1 git@cocodot.unfuddle.com:cocodot/ey-data.git #{ey_data_dir} && cd #{ey_data_dir}'"
  #Get the latest copy of the configs
  execute ey_data_cmd do
    command ey_data_cmd
  end
  
  execute "Ensure cocodot shared config dir" do
    command "mkdir -p /data/cocodot/shared/config"
  end

  ey_data_env_conf_dir = "#{ey_data_dir}/shared_config/#{node['environment']['name']}"
  sym_cmd  = "sh -c 'ls -1  #{ey_data_env_conf_dir} | grep \.yml$ | xargs -n1 -IFILE cp -f #{ey_data_env_conf_dir}/FILE /data/cocodot/shared/config/FILE'"
  execute sym_cmd do
    command sym_cmd
  end
end
