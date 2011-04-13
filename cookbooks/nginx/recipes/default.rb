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


  ####################################################
  ## Add client_max_body_size to 10mb to nginx.conf ##
  ####################################################
  ey_cloud_report "nginx" do
    message "Adding client_max_body_size to 10mb to nginx.conf"
  end

  begin
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
  end


  ########################################################
  ## Add large_client_header_buffers 8 8k to nginx.conf ##
  ########################################################
  ey_cloud_report "nginx" do
    message "Adding large_client_header_buffers 8 8k to nginx.conf"
  end

  begin
    nginx_conf_path = '/etc/nginx/nginx.conf'
    conf = open(nginx_conf_path).read
    if !conf.include?('client_max_body_size')
      directive = "  large_client_header_buffers 8 8k;"
      lines = conf.split("\n")
      insert_after = lines.index "http {"
      lines.insert(insert_after+1,directive)
      File.open(nginx_conf_path, 'w') do |f|  
        f.puts lines.join("\n")
      end
    end
  end
  
  execute "Restart nginx" do
    command %Q{
      /etc/init.d/nginx restart
    }
  end
  
end