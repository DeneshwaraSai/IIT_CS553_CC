ssh cc@129.114.108.167 -i KP_JAN_31.pem

sudo lxc launch images:ubuntu/22.04 vm1 --vm -c limits.cpu=4 -c limits.memory=4GiB
 
sudo lxc launch images:ubuntu/22.04 container1 -c limits.cpu=4 -c limits.memory=4GiB