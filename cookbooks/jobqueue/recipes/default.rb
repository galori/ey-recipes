#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['solo','app_master'].include?(node[:instance_role])
  # Install the JobQueue monit file.
  template '/etc/monit.d/jobqueue.monitrc' do
    message "Installing JobQueue Monit Config"
    owner node[:owner_name]
    group node[:owner_name]
    source 'jobqueue.monitrc.erb'
    variables({
      :env => 'staging',
    })
  end

  execute "monit quit"
end