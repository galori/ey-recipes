#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['app','app_master','solo'].include?(node[:instance_role])
  run_for_app('cocodot') do
    ey_cloud_report "xorg" do
      message "Installing X packages for flash"
    end

    execute "sh -c 'cp -rfv /data/binaries/x11-packages/* /engineyard/portage/packages/'"
    execute "emerge -k xorg-server nss nspr gtk+"
    execute "cp /data/binaries/flashplayer /usr/local/bin/"
  end
end
