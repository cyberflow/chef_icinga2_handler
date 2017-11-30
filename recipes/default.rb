#
# Cookbook Name:: chef_icinga2_handler
# Recipe:: default
#
# Copyright:: 2017, servers.com, All Rights Reserved.

# Disable icinga2 handler in why-run mode
if Chef::Config[:why_run]
  Chef::Log.warn('Running in why-run mode, skipping chef_icinga2_handler')
  return
end

include_recipe 'chef_handler'

cookbook_file "#{Chef::Config[:file_cache_path]}/chef-icinga2-handler.rb" do
  source 'chef-icinga2-handler.rb'
  mode 0600
end.run_action(:create)

chef_handler 'Icinga2Reporting' do
  source "#{Chef::Config[:file_cache_path]}/chef-icinga2-handler.rb"
  arguments [
    icinga2_host:    node['chef_icinga2_handler']['icinga2_host'],
    icinga2_port:    node['chef_icinga2_handler']['icinga2_port'],
    icinga2_user:    node['chef_icinga2_handler']['icinga2_user'],
    icinga2_pass:    node['chef_icinga2_handler']['icinga2_pass'],
    icinga2_service: node['chef_icinga2_handler']['icinga2_service'],
  ]
  supports report: true, exception: true
  action :nothing
end.run_action(:enable)
