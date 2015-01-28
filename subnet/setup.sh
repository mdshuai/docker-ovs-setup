#!/bin/bash
bridge_ip=$1 //10.244.3.1
bridge_mask=$2 //255.255.255.0
base_network=$3 //10.244.0.0/16

ovs-vsctl del-br br0 || true
ovs-vsctl add-br br0 -- set Bridge br0 fail-mode=secure
# ovs-vsctl set bridge br0 stp_enable=true
ovs-vsctl set bridge br0 protocols=OpenFlow13

ovs-vsctl del-port br0 vxlan0 || true
ovs-vsctl add-port br0 vxlan0 -- set Interface vxlan0 type=vxlan options:remote_ip="flow" options:key="flow" ofport_request=10



ip link del vlinuxbr || true
ip link add vlinuxbr type veth peer name vovsbr
ip link set vlinuxbr up
ip link set vovsbr up
ip link set vlinuxbr txqueuelen 0
ip link set vovsbr txqueuelen 0

ovs-vsctl del-port br0 vovsbr || true
ovs-vsctl add-port br0 vovsbr -- set Interface vovsbr ofport_request=9

# Alternative is to use an OVS internal port
# ovs-vsctl add-port br0 itap -- set Interface itap type=internal ofport_request=9
# ip link set itap up
# brctl addif lbr0 itap

cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-lbr0
DEVICE=lbr0
ONBOOT=yes
TYPE=Bridge
BOOTPROTO=static
IPADDR=${bridge_ip}
NETMASK=${bridge_mask}
STP=no
EOF

service network restart

# Sometimes network restart still doesn't bring the bridge up
ip link set lbr0 up

brctl addif lbr0 vlinuxbr

//ip route del 10.244.3.0/24 dev lbr0  proto kernel  scope link  src 10.244.3.1
ip route add $base_network dev lbr0  proto kernel  scope link  src $bridge_ip
