#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['solo','app_master'].include?(node[:instance_role])
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
        :pid_file => '/tmp/job_queue.pid'
      })
    end

    execute "monit quit"
  end
end
