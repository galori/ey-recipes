#execute "testing" do
#  command %Q{
#    echo "i ran at #{Time.now}" >> /root/cheftime
#  }
#end

# uncomment if you want to run postgres recipe
#require_recipe 'postgres'

# uncomment if you want to run couchdb recipe
# require_recipe "couchdb"

# uncomment to turn use the MBARI ruby patches for decreased memory usage and better thread/continuationi performance
# require_recipe "mbari-ruby"

# uncomment to turn on thinking sphinx/ultra sphinx. Remember to edit cookbooks/sphinx/recipes/default.rb first!
 require_recipe "sphinx"

#uncomment to turn on memcached
#require_recipe "memcached"

#uncomment to run the authorized_keys recipe
#require_recipe "authorized_keys"

#uncomment to run the eybackup_slave recipe
#require_recipe "eybackup_slave"

#uncomment to run the ssmtp recipe
#require_recipe "ssmtp"

#uncomment to run the mongodb recipe
# require_recipe "mongodb"

#uncomment to run the sunspot recipe
# require_recipe "sunspot"
#
#uncomment to run the exim recipe

if false
require_recipe "exim::auth"
if false
exim_instance = if node.engineyard.environment.solo_cluster?
                  node.engineyard.environment.instances.first
                else
                  node.engineyard.environment.utility_instances.find {|x| x.name == "exim"}
                end
end

#if node.engineyard == exim_instance
if true
  exim_auth "auth" do
    my_hostname 'cocodot.com'
    smtp_host 'smtp.sendgrid.net:587'
    username 'gal@cocodot.com'
    password 'c0c0d0t!'
  end
else
  Chef::Log.info "exim server is #{exim_instance.id}"
  ssmtp_conf "default" do
    mailhub exim_instance.public_hostname
    rewrite_domain "domain.com"
    from_line_override true
  end
end
end

#uncomment to run the exim::auth recipe

#uncomment to run the resque recipe
#require_recipe "resque"

#uncomment to run the redis recipe
#require_recipe "redis"

#require_recipe "logrotate"
#
#uncomment to use the solr recipe
#require_recipe "solr"

#uncomment to include the emacs recipe
#require_recipe "emacs"

#uncomment to include the eybackup_verbose recipe
#require_recipe "eybackup_verbose"
