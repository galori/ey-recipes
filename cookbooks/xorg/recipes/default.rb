#
# Cookbook Name:: JobQueue
# Recipe:: default
#

require 'etc'

if ['solo','util'].include?(node[:instance_role])
  run_for_app('cocodot') do
    ey_cloud_report "xorg" do
      message "Installing X packages for flash"
    end

    execute "sh -c 'cp -prfv /data/ey-data/binaries/x11-packages/* /engineyard/portage/packages/'"
    execute "emerge -k xorg-server nss nspr gtk+"
    execute "cp -pf /data/ey-data/binaries/flashplayer /usr/local/bin/"
  end
end
