# Jetstream-Salt-States

A collection of salt states used to deploy jetstream-cloud.org

Live states are applied from the IU_production branch.


## Run locally instructions

Doesn't use the gitfs stuff.

Install or spin up some boxes.

Pick a master node.

Ensure you can ssh as root from it to the other nodes. Then run on each:

    yum install -y https://repo.saltstack.com/yum/redhat/salt-repo-latest-2.el7.noarch.rpm
 
On master:

    yum install -y salt-master salt-ssh 
    systemctl enable salt-master
    systemctl start salt-master

On minions, including master node (change master_ip to yours):

    master_ip=192.168.100.1
    yum install -y salt-minion 
    echo "master: $master_ip" > /etc/salt/minion
    systemctl enable salt-minion
    systemctl start salt-minion
    
On master (answer Y to first command):

    salt-key -A
    salt '*' cmd.run 'uptime'

Hopefully now you have a working salt install. Clone the git repo:

    git clone git@github.com:jetstream-cloud/Jetstream-Salt-States.git
    cd Jetstream-Salt-States
    git checkout --track -b tacc origin/tacc

Create vars & passwords files that will contain variables specific to your cluster:

    echo "salt-master-ip: $master_ip" >> ~/vars.sls
    touch ~/passwords.sls
    
Run the pub script to copy everything into the standard salt directories:

    ./pub

Now run salt commands to configure your nodes, e.g.:

    salt node01 state.apply
    salt '*' state.apply





