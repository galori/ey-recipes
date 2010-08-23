#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['solo','app_master'].include?(node[:instance_role])
  # Install the JobQueue monit file.
  run_for_app('cocodot') do
    template '/etc/monit.d/jobqueue.monitrc' do
      ey_cloud_report "JobQueue" do
        message "Installing JobQueue Monit Config"
      end
      owner node[:owner_name]
      group node[:owner_name]
      source 'jobqueue.monitrc.erb'
      variables({
        :env      => 'staging',
        :pid_file => '/tmp/job_queue.pid'
      })
    end

    execute "monit quit"
  end
end
