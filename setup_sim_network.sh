#!/bin/bash -xe
ip netns del neta || true
ip netns add neta
ip link add vetha type veth peer name vethain
ip link set vethain netns neta
ip netns exec neta ip link set lo up
ip netns exec neta ip link set dev vethain name eth0
ip netns exec neta ip link set dev eth0 addr 00:00:00:00:00:01
ip netns exec neta ip link set dev eth0 mtu 1450
ip netns exec neta ip addr add 10.0.0.1/24 dev eth0
ip netns exec neta ip link set eth0 up

ip netns del netb || true
ip netns add netb
ip link add vethb type veth peer name vethbin
ip link set vethbin netns netb
ip netns exec netb ip link set lo up
ip netns exec netb ip link set dev vethbin name eth0
ip netns exec netb ip link set dev eth0 addr 00:00:00:00:00:02
ip netns exec netb ip link set dev eth0 mtu 1450
ip netns exec netb ip addr add 10.0.0.2/24 dev eth0
ip netns exec netb ip link set eth0 up


ovs-vsctl del-br br0 || true
ovs-vsctl add-br br0 -- set Bridge br0 fail-mode=secure
ovs-vsctl set bridge br0 stp_enable=true
ovs-vsctl set bridge br0 protocols=OpenFlow13

ovs-vsctl del-port br0 vetha || true
ovs-vsctl del-port br0 vethb || true
#ovs-vsctl del-port br0 gre0
ovs-vsctl del-port br0 vxlan0
ovs-vsctl add-port br0 vetha -- set Interface vetha ofport_request=1
ovs-vsctl add-port br0 vethb -- set Interface vethb ofport_request=2
#ovs-vsctl add-port br0 gre0 -- set Interface gre0 type=gre options:remote_ip="192.168.122.26" ofport_request=10
ovs-vsctl del-port br0 vxlan0 || true
ovs-vsctl add-port br0 vxlan0 -- set Interface vxlan0 type=vxlan options:remote_ip="192.168.122.26" options:key="flow" ofport_request=10
