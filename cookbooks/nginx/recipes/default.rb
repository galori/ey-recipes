# add customization to the nginx configs

if ['solo','app_master'].include?(node[:instance_role])


  ##############################################
  ## ADD Mime Types to the nginx default list ##
  ##############################################
  ey_cloud_report "nginx" do
      message "Adding mime types to nginx config"
  end
  
  template '/etc/nginx/mime.types' do
    source 'mime_types.erb'
  end
  
end