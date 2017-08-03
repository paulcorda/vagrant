# -*- mode: ruby -*-
# # vi: set ft=ruby :

# Install required vagrant plugins
required_plugins = %w(vagrant-hostsupdater)
required_plugins.each do |plugin|
    system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

# Required ruby gems & classes
require 'yaml'
require './ruby/classes/hash.rb'

# Vagrant configs
Vagrant.require_version '>= 1.9.7'
VAGRANTFILE_API_VERSION = '2'

# Load config files
vagrantconfig = YAML.load_file('Vagrantconfig.yml')

if File.exist?('Vagrantconfig.local.yml')
  vagrantconfig_local = YAML.load_file('Vagrantconfig.local.yml')
  vagrantconfig.rmerge!(vagrantconfig_local)
end

if !vagrantconfig.has_key? 'boxes'
  abort('No \'boxes\' configured!')
end

# base synced folders
syncedfolders = {}
if vagrantconfig.has_key? 'synced_folders'
  syncedfolders = vagrantconfig['synced_folders']
end

# base provisioners
provisioners = {}
if vagrantconfig.has_key? 'provisioners'
  provisioners = vagrantconfig['provisioners']
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  vagrantconfig['boxes'].keys.sort.each do |boxname|
    boxconfig = vagrantconfig['boxes'][boxname]

    config.vm.define boxname do |box|
      # Set misc options
      box.vm.provider "virtualbox" do |v|
        v.memory = boxconfig['memory']
        v.cpus   = boxconfig['cpus']
      end

      # Increase timeout as per the doctor's prescription (enable if timeout issues)
      # box.vm.boot_timeout = 600;

      # Go with https://atlas.hashicorp.com boxes
      box.vm.box = boxconfig['box_name']
      box.vm.box_check_update = false

      # Networking configurations
      box.vm.network "private_network", ip: boxconfig['ip']
      box.vm.hostname = boxconfig['hostname']

      # run synced_folders
      if boxconfig.has_key? 'synced_folders'
        syncedfolders.rmerge!(boxconfig['synced_folders'])
      end

      syncedfolders.each do |name, opt|
        box.vm.synced_folder opt['from'], opt['to'], opt['options']
      end

      # run provisioning
      if boxconfig.has_key? 'provisioners'
        provisioners.rmerge!(boxconfig['provisioners'])
      end

      # Provisioning - shell
      if provisioners.has_key? 'shell'
        provisioners['shell'].each do |id, shell|
          box.vm.provision :shell, :path => shell['path']
        end
      end

      # Provisioning - Docker & Docker Compose
      if provisioners.has_key? 'docker'
        box.vm.provision :docker
      end

      if provisioners.has_key? 'docker_compose'
        provisioners['docker_compose'].each do |id, docker_compose|
          options = docker_compose['options']

          box.vm.provision :docker_compose, :yml => docker_compose['path'], rebuild: options['rebuild'], run: options['run']
        end
      end
    end
  end
end
