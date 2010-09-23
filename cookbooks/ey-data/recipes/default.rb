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

  #Get the latest copy of the configs
  execute "Get Latest ey-data" do
    branch = node['environment']['framework_env']
    command "sudo -u deploy sh -c 'rm -Rf #{ey_data_dir}; git clone --depth 1 git@cocodot.unfuddle.com:cocodot/ey-data.git #{ey_data_dir} && cd #{ey_data_dir} && git checkout -b #{branch} origin/#{branch}'"
  end
  
  #Link the configs to the shared config dir
  shared_config_dir     = "#{ey_data_dir}/shared_config"
  app_shared_config_dir = "/data/cocodot/shared/config"
  Dir.open(shared_config_dir).each do |f|
    next if f =~ /^\./
    execute "Linking #{f}" do
      command "ln -sf '#{shared_config_dir}/#{f}' '#{app_shared_config_dir}/#{f}'"
    end
  end
end
