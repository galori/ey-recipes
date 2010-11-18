#
# Cookbook Name:: mongodb
# Recipe:: default
#


#Add mongo info to the database YAML
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
    props['mongo'] = {}
    props['mongo']['database'] = 'cocodot' 
    props['mongo']['capsize']  = mcap
    props['mongo']['host']     = props['host']
  end 
  File.open(db_yml_path, 'w') do |f|
    f.write YAML.dump(db_yml)
  end          
end
  
if ['db_master','solo'].include?(node[:instance_role])

  # If using masterslave to replicate from a remote master, this
  # requires a tunnel to be created and running on port 27027
  remote_master     = 'localhost:27027'
  local_master      = 'localhost'
  
  #node[:utility_instances].each do |util_instance|
  #  if util_instance[:name].match(/(master|masterslave)$/)
  #    local_master = util_instance[:hostname]
  #  end
  #end
  
  mongodb_options = "--master"
  #mongodb_options = "--master --slave --source=#{remote_master}" if node[:name].match(/masterslave$/)
  #mongodb_options = "--slave --source=#{local_master}" if node[:name].match(/slave(\d*)$/)  
  
  enable_package "dev-db/mongodb-bin" do
    version "1.6.3"
  end
  
  package "dev-db/mongodb-bin" do
    version "1.6.3"
    action :install
  end
  
  directory '/db/mongodb/data' do
    owner 'mongodb'
    group 'mongodb'
    mode  '0755'
    action :create
    recursive true
  end

  directory '/db/mongodb/log' do
    owner 'mongodb'
    group 'mongodb'
    mode '0755'
    action :create
    recursive true
  end
  
  directory '/var/run/mongodb' do
    owner 'mongodb'
    group 'mongodb'
    mode '0755'
    action :create
    recursive true
  end  
  
  remote_file "/etc/logrotate.d/mongodb" do
    owner "root"
    group "root"
    mode 0755
    source "mongodb.logrotate"
    backup false
    action :create
  end
  
  template "/etc/conf.d/mongodb" do
    source "mongodb.conf.erb"
    owner "root"
    group "root"
    mode 0755
    variables({
      :mongodb_options => mongodb_options
    })
  end  
  
  execute "enable-mongodb" do
    command "rc-update add mongodb default"
    action :run
  end  
  
  execute "start-mongodb" do
    command "/etc/init.d/mongodb restart"
    action :run
    not_if "/etc/init.d/mongodb status"
  end  
end
