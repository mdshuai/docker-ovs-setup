#!/bin/bash

set -e
set -x

network_ip=10.1.0.0/16
tap_ip=10.1.0.1
new_ip=$1

net_container=$(docker run -d kubernetes/pause)
echo $net_container
pid=$(docker inspect --format "{{.State.Pid}}" ${net_container})
ipaddr=$(docker inspect --format "{{.NetworkSettings.IPAddress}}" ${net_container})
ipaddr_sub=$(docker inspect --format "{{.NetworkSettings.IPPrefixLen}}" ${net_container})
veth_host=$(jq .network_state.veth_host /var/lib/docker/execdriver/native/${net_container}/state.json | tr -d '"')
echo $veth_host
echo $pid
echo $ipaddr/$ipaddr_sub

brctl delif docker0 $veth_host
ovs-vsctl add-port br0 $veth_host

#bridge_ip=$(ip -4 addr show dev docker0 | grep inet | awk '{print $2}')
#echo $bridge_ip

#bridge_sub=$(echo $bridge_ip | cut -d'.' -f1,2)
#bridge_sub=${bridge_sub}.0.0/16

#ip_routes=$(nsenter -n -t $pid -- ip route show)
#echo $ip_routes
 
#del_rule_cmd="ip route del $bridge_sub dev eth0 proto kernel scope link src $ipaddr"
#nsenter -n -t $pid -- $del_rule_cmd
#del_default_rule_cmd="ip route del default via $bridge_ip dev eth0"
#nsenter -n -t $pid -- $del_default_rule_cmd

del_ip_cmd="ip addr del $ipaddr/$ipaddr_sub dev eth0"
nsenter -n -t $pid -- $del_ip_cmd

add_ip_cmd="ip addr add $new_ip/16 dev eth0"
nsenter -n -t $pid -- $add_ip_cmd

#new_ip_net=$(echo $new_ip | cut -d'.' -f1,2,3)
#new_ip_net=${new_ip_net}.0/24
#del_new_rule_cmd="ip route del $new_ip_net dev eth0 proto kernel scope link src $new_ip"
#new_ip_net=$(echo $new_ip | cut -d'.' -f1,2)
#new_ip_net=${new_ip_net}.0.0/16
#nsenter -n -t $pid -- $del_new_rule_cmd
#add_new_rule_cmd="ip route add $new_ip_net dev eth0 proto kernel scope link src $new_ip"
#nsenter -n -t $pid -- $del_new_rule_cmd
add_default_cmd="ip route add default via $tap_ip"
nsenter -n -t $pid -- $add_default_cmd

shift
docker_args=$@
cidfile=/tmp/osdn-cid_$RANDOM
docker run --cidfile $cidfile --net=container:${net_container} $docker_args
cid=$(cat $cidfile)
docker wait $cid || true
docker rm -f $cid || true
docker rm -f $net_container
