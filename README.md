# Jetstream-Salt-States

A collection of salt states used to deploy jetstream-cloud.org

Live states are applied from the IU_production branch.


## Run locally instructions

Doesn't use the gitfs stuff.

Install or spin up some boxes.

Pick a master node.

Ensure you can ssh as root from it to the other nodes. Then run on each:

    yum install -y epel-release
    yum install -y salt git crudini GitPython

On master:

    yum install -y salt-master salt-minion salt-ssh salt-syndic salt-cloud
    systemctl enable salt-master
    systemctl start salt-master

On minions (including master):

    yum install -y salt-minion
    crudini  --set /etc/salt/minion '' master [master_ip]
    systemctl start salt-minion

On master:

    salt-key -A (Y)
    salt '*' cmd.run 'uptime'

Hopefully now you have a working salt install. Clone the git repo 

    git clone git@github.com:jetstream-cloud/Jetstream-Salt-States.git
    cd Jetstream-Salt-States
    git checkout --track -b tacc origin/tacc
    ./pub



  950  mkdir -p /etc/salt/gpgkeys
  951  chmod 0700 /etc/salt/gpgkeys
  952  gpg --gen-key --homedir /etc/salt/gpgkeys
  953  yum install rngtools
  954  yum install rng-tools
  955  gpg --gen-key --homedir /etc/salt/gpgkeys
  956  gpg-agent --homedir=/etc/salt/gpgkeys  --daemon
  957  echo $GPG_AGENT_INFO
  958  GPG_AGENT_INFO=/etc/salt/gpgkeys/S.gpg-agent:5834:1; export GPG_AGENT_INFO;
  959  gpg --gen-key --homedir /etc/salt/gpgkeys

