#
# Cookbook Name:: cronjobs
# Recipe:: default
#

require 'etc'

if ['solo','app_master'].include?(node[:instance_role])
  update_file "/tmp/cron_update_header" do
    action :rewrite

    body <<-CRON
      RAILS_ENV="#{node['environment']['framework_env']}"
      RACK_ENV="#{node['environment']['framework_env']}"
    CRON
  end

  execute "add environment variables to cron" do
    command "sudo -u deploy crontab /tmp/cron_update_header"
  end

  file "/tmp/cron_update_header" do
    action :delete
  end

  cron "Update Accessible Lookup" do
    minute "0"
    hour "*/1"
    user "deploy"
    command "cd /data/cocodot/current && script/runner lib/cron/update_accessible_lookup.rb > /data/cocodot/shared/cron_logs/update_accessible_lookup.log"
  end

  cron "Category Rebuild" do
    minute "0"
    hour "*/1"
    user "deploy"
    command "cd /data/cocodot/current && script/runner 'Category.rebuild!' > /data/cocodot/shared/cron_logs/category_rebuild.log"
  end

  cron "Mark & Purge Bounces" do
    minute "*/30"
    user "deploy"
    command "cd /data/cocodot/current && rake cocodot:mark_and_purge_bounces > /data/cocodot/shared/cron_logs/mark_and_purge_bounces.log"
  end

  if node['environment']['framework_env'] == 'production'
    cron "Recurring Biller" do
      minute "0"
      hour "1"
      day  "*/1"
      user "deploy"
      command "echo recurringbiller > /data/cocodot/shared/cron_logs/recurring_biller.log"
      #command "cd /data/cocodot/current && ruby script/runner script/recurring_biller > /data/cocodot/shared/cron_logs/recurring_biller.log"
    end
  end
end
