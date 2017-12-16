# -*- mode: ruby -*-
# # vi: set ft=ruby :

# Required ruby gems & classes
require 'yaml'
require './ruby/classes/hash.rb'

# Load Vagrant configs
Vagrantconfig = YAML.load_file('Vagrantconfig.yml')

if File.exist?('Vagrantconfig.local.yml')
  Vagrantconfig_local = YAML.load_file('Vagrantconfig.local.yml')
  Vagrantconfig.rmerge!(Vagrantconfig_local)
end

if !Vagrantconfig.has_key? 'config'
  abort('No \'config\' key set!')
end

# Vagrant configs
Vagrant.require_version Vagrantconfig['config']['require_version']
VAGRANTFILE_API_VERSION =  Vagrantconfig['config']['api_version']

# Install required vagrant plugins
Vagrantconfig['config']['required_plugins'].each do |plugin|
    system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

if !Vagrantconfig.has_key? 'boxes'
  abort('No \'boxes\' configured. Nothing to do!')
end

# base synced folders
syncedfolders = {}
if Vagrantconfig.has_key? 'synced_folders'
  syncedfolders = Vagrantconfig['synced_folders']
end

# base provisioners
provisioners = {}
if Vagrantconfig.has_key? 'provisioners'
  provisioners = Vagrantconfig['provisioners']
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  Vagrantconfig['boxes'].keys.sort.each do |boxname|
    boxconfig = Vagrantconfig['boxes'][boxname]

    config.vm.define boxname do |box|
      # Set misc options
      box.vm.provider "virtualbox" do |v|
        v.memory = boxconfig['memory']
        v.cpus   = boxconfig['cpus']
      end

      # Increase timeout as per the doctor's prescription (enable if timeout issues)
      box.vm.boot_timeout = 600;

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
          env_hash = Hash.new

          if File.exist?(docker_compose['env_path'])
            env_hash = Hash[*File.read(docker_compose['env_path']).split(/[=\n]+/)]

            # ignore keys (lines) starting with #
            env_hash.delete_if { |key, value| key.to_s.match(/^#.*/) }
          end

          box.vm.provision :docker_compose,
            yml: docker_compose['yml_path'],
            env: env_hash,
            rebuild: true,
            run: 'always'
        end
      end
    end
  end
end
