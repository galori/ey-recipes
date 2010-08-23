#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['solo','app_master'].include?(node[:instance_role])
  # Install the JobQueue monit file.
  run_for_app('cocodot') do
    ey_cloud_report "JobQueue" do
        message "Installing Monit Email Alerts"
    end
 
    template '/etc/monit.d/email_alerts.monitrc' do
     owner node[:owner_name]
      group node[:owner_name]
      source 'email_alerts.monitrc.erb'
    end

    execute "monit quit"
  end
end
