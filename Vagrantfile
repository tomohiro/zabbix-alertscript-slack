# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box      = 'centos/7'
  config.vm.hostname = 'zabbix-server'

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook = 'provisioning/site.yml'
  end
end
