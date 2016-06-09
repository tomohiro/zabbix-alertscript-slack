# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box      = 'centos/7'
  config.vm.hostname = 'zabbix-server'

  # Port fowarding port 80 to 10080.
  # You can access to the Zabbix web console via http://localhost:10080/zabbix
  config.vm.network :forwarded_port, guest: 80, host: 10080

  config.vm.provision 'ansible_local' do |ansible|
    ansible.playbook          = '/home/vagrant/sync/provisioning/site.yml'
    ansible.provisioning_path = '/home/vagrant/sync/provisioning'
    ansible.galaxy_role_file  = '/home/vagrant/sync/provisioning/requirements.yml'
    ansible.extra_vars = {
      zabbix_endpoint: 'http://localhost:10080/zabbix',
      slack_webhook_url: ENV['SLACK_WEBHOOK_URL']
    }
  end
end
