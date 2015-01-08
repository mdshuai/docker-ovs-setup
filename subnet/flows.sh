#!/bin/bash

ovs-ofctl del-flows -O OpenFlow13 br0 
ovs-ofctl add-flow -O OpenFlow13 br0 "table=0,priority=200,in_port=10,ip,nw_dst=10.244.3.0/24,actions=output:9"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=0,priority=200,in_port=10,arp,nw_dst=10.244.3.0/24,actions=output:9"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=0,priority=200,in_port=9,ip,nw_dst=10.244.2.0/24,actions=set_field:192.168.122.207->tun_dst,output:10"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=0,priority=200,in_port=9,arp,nw_dst=10.244.2.0/24,actions=set_field:192.168.122.207->tun_dst,output:10"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=0,priority=200,in_port=9,ip,nw_dst=10.244.1.0/24,actions=set_field:192.168.122.26->tun_dst,output:10"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=0,priority=200,in_port=9,arp,nw_dst=10.244.1.0/24,actions=set_field:192.168.122.26->tun_dst,output:10"


