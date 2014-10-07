#!/bin/bash -xe
ip netns del netc || true
ip netns add netc
ip link add vethc type veth peer name vethcin
ip link set vethcin netns netc
ip netns exec netc ip link set lo up
ip netns exec netc ip link set dev vethcin name eth0
ip netns exec netc ip link set dev eth0 addr 00:00:00:00:00:03
ip netns exec netc ip link set dev eth0 mtu 1450
ip netns exec netc ip addr add 10.0.0.3/24 dev eth0
ip netns exec netc ip link set eth0 up

ip netns del netd || true
ip netns add netd
ip link add vethd type veth peer name vethdin
ip link set vethdin netns netd
ip netns exec netd ip link set lo up
ip netns exec netd ip link set dev vethdin name eth0
ip netns exec netd ip link set dev eth0 addr 00:00:00:00:00:04
ip netns exec netd ip link set dev eth0 mtu 1450
ip netns exec netd ip addr add 10.0.0.4/24 dev eth0
ip netns exec netd ip link set eth0 up


ovs-vsctl del-br br0 || true
ovs-vsctl add-br br0 -- set Bridge br0 fail-mode=secure
ovs-vsctl set bridge br0 stp_enable=true
ovs-vsctl set bridge br0 protocols=OpenFlow13

ovs-vsctl del-port br0 vethc || true
ovs-vsctl del-port br0 vethd || true
ovs-vsctl add-port br0 vethc -- set Interface vethc ofport_request=1
ovs-vsctl add-port br0 vethd -- set Interface vethd ofport_request=2
#ovs-vsctl add-port br0 gre0 -- set Interface gre0 type=gre options:remote_ip="192.168.122.207" ofport_request=10
ovs-vsctl del-port br0 vxlan0 || true
ovs-vsctl add-port br0 vxlan0 -- set Interface vxlan0 type=vxlan options:remote_ip="192.168.122.207" options:key="flow" ofport_request=10
