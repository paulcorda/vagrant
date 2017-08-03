# Vagrant

## TL;DR
Run ```$ vagrant up``` to set up a basic LEMP box with networking and hosts configured.  
Check ```Vagrantconfig.yml``` to see it's default settings.  

## Config
The default boxes are configured via an yml file, ```Vagrantconfig.yml```.  
To override the default config file, or define new custom boxes, the possibility  
of a non-source-controlled file has been enabled: ```Vagrantconfig.local.yml```.  

The local file can be used to safely override any default changes or define totally new,  
custom boxes.
