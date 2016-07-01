# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box      = 'centos/7'
  config.vm.hostname = 'zabbix-server'

  # Set auto_update to false, if you do NOT want to check the correct
  # additions version when booting this machine
  #   https://github.com/dotless-de/vagrant-vbguest
  if Vagrant.has_plugin? 'vagrant-vbguest'
    config.vbguest.auto_update = false
  end

  # Disable rsync synced folder configuration at centos/7 Vagrantfile.
  config.vm.synced_folder '.', '/home/vagrant/sync', disabled: true

  # Enable virtualbox synced folder configuration to /etc/ansible
  config.vm.synced_folder './provisioning', '/etc/ansible'

  # Port fowarding port 80 to 10080.
  # You can access to the Zabbix web console via http://localhost:10080/zabbix
  config.vm.network :forwarded_port, guest: 80, host: 10080

  config.vm.provision 'ansible_local' do |ansible|
    ansible.inventory_path    = '/etc/ansible/inventory'
    ansible.limit             = 'all'
    ansible.playbook          = '/etc/ansible/site.yml'
    ansible.provisioning_path = '/etc/ansible'
    ansible.galaxy_role_file  = '/etc/ansible/requirements.yml'
    ansible.extra_vars        = {
      zabbix_endpoint: 'http://localhost:10080/zabbix',
      slack_webhook_url: ENV['SLACK_WEBHOOK_URL']
    }
  end
end
