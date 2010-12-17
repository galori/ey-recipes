#Add mongo info to the database YAML

if ['app_master','app', 'util','solo'].include?(node[:instance_role])
  node['applications'].each do |app_name,app_config|
    db_yml_path = "/data/#{app_name}/shared/config/database.yml"
    raise "Could not find #{db_yml_path}" unless File.exists? db_yml_path
    db_yml = YAML.load File.open(db_yml_path)

    if node['environment']['framework_env'] == 'production'
      mcap = 10737418240 #10GB
    else
      mcap = 524288000   #500MB
    end

    db_yml.each do |env,props|
      props['adapter']  = 'mysql2'
      props['database'] = 'cocodot'
       
      props['mongo'] = {}
      props['mongo']['database'] = 'cocodot' 
      props['mongo']['capsize']  = mcap
      props['mongo']['host']     = props['host']
    end 

    File.open(db_yml_path, 'w') do |f|
      f.write YAML.dump(db_yml)
    end          
  end
end
 
