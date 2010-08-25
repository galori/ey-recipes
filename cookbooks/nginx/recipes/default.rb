# add customization to the nginx configs

if ['solo','app_master'].include?(node[:instance_role])


  ##############################################
  ## ADD Mime Types to the nginx default list ##
  ##############################################
  ey_cloud_report "nginx" do
      message "Adding mime types to nginx config"
  end
  
  execute "adding mime types to nginx config" do
    additional_mime_types = [
      {:content_type  => 'application/xslt+xml', :extension => 'xsl'},
      {:content_type  => 'application/maltese',  :extension => 'maltese'}
    ]
  
    mime_types_string = additional_mime_types.map{|m| "    #{m[:content_type]}                  #{m[:extension]};\n"}.join("") 

    mime_types_file_path = "/etc/nginx/mime.types"
    file = open(mime_types_file_path)
    mime_types = file.read
    mime_types.gsub!(/}$/,"#{mime_types_string}}")
  
    File.open(mime_types_file_path, 'w') do |f|  
      f.puts mime_types
    end
  end
end