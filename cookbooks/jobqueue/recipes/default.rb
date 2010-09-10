#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['solo','app_master','app'].include?(node[:instance_role])
  # Install the JobQueue monit file.
  run_for_app('cocodot') do
    ey_cloud_report "JobQueue" do
        message "Installing JobQueue Monit Config"
    end
 
    template '/etc/monit.d/jobqueue.monitrc' do
      owner node[:owner_name]
      group node[:owner_name]
      source 'jobqueue.monitrc.erb'
      variables({
        :env      => node['environment']['framework_env'],
        :pid_file => '/tmp/job_queue.pid',
        :xvfb_pid_file => '/tmp/xvfb.pid'
      })
    end

    execute "monit quit"
  end
else
  #Since /etc/monit.d is peristed on /data lets delete this config on servers we don't want it on
  execute "sh -c '/bin/rm /etc/monit.d/jobqueue.monitrc; true'"
  execute "sh -c '/bin/rm /etc/monit.d/jobqueue.monitrc*; true'"
end
