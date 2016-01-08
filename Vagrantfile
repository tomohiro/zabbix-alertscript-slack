# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box      = 'centos/7'
  config.vm.hostname = 'zabbix-server'

  config.vm.synced_folder '.', '/home/vagrant/sync', type: 'rsync'

  # Port fowarding port 80 to 10080.
  # You can access to the Zabbix web console via http://localhost:10080/zabbix
  config.vm.network :forwarded_port, guest: 80, host: 10080

  config.vm.provision 'ansible' do |ansible|
    ansible.playbook   = 'provisioning/site.yml'
    ansible.extra_vars = {
      zabbix_endpoint: 'http://localhost:10080/zabbix',
      slack_webhook_url: ENV['SLACK_WEBHOOK_URL']
    }
  end
end
