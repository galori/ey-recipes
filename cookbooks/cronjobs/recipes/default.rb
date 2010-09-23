#
# Cookbook Name:: cronjobs
# Recipe:: default
#

require 'etc'

if ['util'].include?(node[:instance_role])
  execute "Create cronlogs directory" do
    command "sh -c 'mkdir -p /data/cocodot/shared/cron_logs'"
  end
    
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
  
  cron "Purge Stale Products and Address Books" do
    user "deploy"
    minute "0"
    hour "1"
    command "cd /data/cocodot/current && rake cocodot:purge_stale_products_and_address_books > /data/cocodot/shared/cron_logs/purge_stale_products_and_address_books.log"
  end

  if node['environment']['framework_env'] == 'production'
    cron "Mark & Purge Bounces" do
      minute "*/30"
      user "deploy"
      command "cd /data/cocodot/current && rake cocodot:mark_and_purge_bounces > /data/cocodot/shared/cron_logs/mark_and_purge_bounces.log"
    end
     
    cron "Recurring Biller" do
      minute "0"
      hour "1"
      day  "*"
      user "deploy"
      command "cd /data/cocodot/current && ruby script/runner script/recurring_biller > /data/cocodot/shared/cron_logs/recurring_biller.log"
    end

    cron "Daily Mailer" do
      user "deploy"
      minute "0"
      hour "1"
      command "cd /data/cocodot/current && ruby script/runner script/daily_mailer > /data/cocodot/shared/cron_logs/daily_mailer.log"
    end

    cron "Non-Sub Initial Blast" do
      user "deploy"
      minute "0"
      hour "1"
      command "cd /data/cocodot/current && rake cocodot:non_sub_initial_blast > /data/cocodot/shared/cron_logs/non_sub_initial_blast.log"
    end
  end
end
