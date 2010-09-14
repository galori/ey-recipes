# add customization to the nginx configs

if ['solo','app_master','app'].include?(node[:instance_role])


  ##############################################
  ## ADD Mime Types to the nginx default list ##
  ##############################################
  ey_cloud_report "nginx" do
      message "Adding mime types to nginx config"
  end
  
  template '/etc/nginx/mime.types' do
    source 'mime_types.erb'
  end

  # execute 'add client_max_body_size to 10mb' do
    nginx_conf_path = '/etc/nginx/nginx.conf'
    conf = open(nginx_conf_path).read
    if !conf.include?('client_max_body_size')
      directive = "  client_max_body_size 10m;"
      lines = conf.split("\n")
      insert_after = lines.index "http {"
      lines.insert(insert_after+1,directive)
      File.open(nginx_conf_path, 'w') do |f|  
        f.puts lines.join("\n")
      end
    end
  # end
  
  execute "Restart nginx" do
    command %Q{
      /etc/init.d/nginx restart
    }
  end
  
end