#
# Cookbook Name:: csync2
# Recipe:: default
#
# Copyright 2014, Heavy Water Operations, LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform']
when "redhat", "centos", "fedora", "amazon"
  install_packages = node[:csync2][:build_packages][:rhel]
when "debian", "ubuntu"
  install_packages = node[:csync2][:build_packages][:ubuntu]
end
install_packages.each do |pkg|
  package pkg
end

node[:csync2][:source][:downloads].each do |k, v|
  remote_file "#{Chef::Config[:file_cache_path]}/#{k}" do
    source v
  end
end

csync2_command = '/usr/sbin/csync2'

execute "Install csync2" do
  cwd Chef::Config[:file_cache_path]
  command <<-EOF
    tar -xzvf #{node[:csync2][:source][:version]}.tar.gz
    cd #{node[:csync2][:source][:version]}
    #{node[:csync2][:src][:configure_opts]}
    make
    make install
  EOF
  not_if { ::File.exists?(csync2_command) }
end

ssl_conf = Chef::EncryptedDataBagItem.load('csync2', node.chef_environment)
[ "csync2.key", "csync2_ssl_cert.csr", "csync2_ssl_cert.pem", "csync2_ssl_key.pem"].each do |name|
  file "/etc/#{name}" do
    content ssl_conf["#{name}"]
  end
end

template "/etc/csync2.cfg" do
  source "csync2.cfg.erb"
end
