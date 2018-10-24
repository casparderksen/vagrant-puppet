# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos7-puppet"

  # HTTP application port
  config.vm.network :forwarded_port, guest: 80, host: 80

  # Create a private network
  config.vm.network "private_network", ip: "192.168.33.10"

  # VirtualBox provider configuration
  config.vm.provider "virtualbox" do |vb|
    vb.name = "CentOS 7 - Puppet"
    vb.memory = "8192"
    vb.cpus = 2
  end

  # Configure Puppet
  config.vm.provision "shell", inline: <<-SCRIPT
      # Install Puppet modules
      cd /vagrant/puppet/environments/development
      /opt/puppetlabs/puppet/bin/r10k puppetfile install

      # Install eyaml keys
      cp -r /vagrant/puppet/eyaml/keys /etc/puppetlabs/puppet/eyaml
      chmod 0700 /etc/puppetlabs/puppet/eyaml
      chmod 0600 /etc/puppetlabs/puppet/eyaml/private*

      # Configure eyaml for vagrant user
      mkdir -p /home/vagrant/.eyaml
      cp /vagrant/puppet/eyaml/config.yaml /home/vagrant/.eyaml
      chown -R vagrant:vagrant /home/vagrant/.eyaml
    SCRIPT

  # Perform Puppet provisioning
  config.vm.provision "puppet" do |puppet|

    # Configure Puppet environment
    puppet.environment_path = "puppet/environments"
    puppet.environment = "development"

    # Configure Puppet options
    puppet.options = [
      #q"--debug",
      "--verbose",
      " --fileserverconfig=/vagrant/puppet/conf/fileserver.conf"
    ]

    # Set additional custom facts for selecting the classes to apply.
    puppet.facter = {
      "role"  => "default"
    }
  end
end
