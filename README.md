# Vagrant

Quickly set up a simple (or complex) VM infrastructure for your project(s).  

## TL;DR
1. Adapt the existing vagrant box configs that are defined in ```Vagrantconfig.yml``` or create your own completely custom ones (use ```Vagrantconfig.local.yml```).  
2. Run ```$ vagrant up {BOX_NAME}``` to spin up a box with networking and hosts configured.  

## Config
* All default boxes are defined in ```Vagrantconfig.yml```.  
* Custom boxes and extensions of default ones should be defined within a vcs-disabled ```Vagrantconfig.local.yml``` file.  
