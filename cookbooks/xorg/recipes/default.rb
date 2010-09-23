#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['app','app_master','solo','util'].include?(node[:instance_role])
  run_for_app('cocodot') do
    ey_cloud_report "xorg" do
      message "Installing X packages for flash"
    end

    execute "sh -c 'cp -rfv /data/ey-data/binaries/x11-packages/* /engineyard/portage/packages/'"
    execute "emerge -k xorg-server nss nspr gtk+"
    execute "cp -f /data/ey-data/binaries/flashplayer /usr/local/bin/"
  end
end
