#
# Cookbook Name:: public-dna
# Recipe:: default
#

require 'etc'

execute "dna" do
  command "sudo chmod +r /etc/chef/dna.json"
end
