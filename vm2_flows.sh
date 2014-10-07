#/bin/bash -xe

ovs-ofctl del-flows -O OpenFlow13 br0 
ovs-ofctl add-flow -O OpenFlow13 br0 "table=0,in_port=1,actions=set_field:10->tun_id,goto_table:1"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=0,in_port=2,actions=set_field:20->tun_id,goto_table:1"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=0,in_port=10,actions=goto_table:1"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=0,actions=goto_table:1"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=10,dl_dst=00:00:00:00:00:03,actions=output:1"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=20,dl_dst=00:00:00:00:00:04,actions=output:2"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=10,dl_dst=00:00:00:00:00:01,actions=set_field:10->tun_id,output:10"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=20,dl_dst=00:00:00:00:00:02,actions=set_field:20->tun_id,output:10"

#ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=10,arp,nw_dst=10.0.0.3,actions=output:1"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=10,dl_type=0x0806,nw_dst=10.0.0.3, actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[], mod_dl_src:00:00:00:00:00:03, load:0x2->NXM_OF_ARP_OP[], move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[], move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[], load:0x000000000003->NXM_NX_ARP_SHA[], load:0x0a000003->NXM_OF_ARP_SPA[],in_port"
#ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=20,arp,nw_dst=10.0.0.4,actions=output:2"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=20,dl_type=0x0806,nw_dst=10.0.0.4, actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[], mod_dl_src:00:00:00:00:00:04, load:0x2->NXM_OF_ARP_OP[], move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[], move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[], load:0x000000000004->NXM_NX_ARP_SHA[], load:0x0a000004->NXM_OF_ARP_SPA[],in_port"
#ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=10,arp,nw_dst=10.0.0.1,actions=output:10"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=10,dl_type=0x0806,nw_dst=10.0.0.1, actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[], mod_dl_src:00:00:00:00:00:01, load:0x2->NXM_OF_ARP_OP[], move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[], move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[], load:0x000000000001->NXM_NX_ARP_SHA[], load:0x0a000001->NXM_OF_ARP_SPA[],in_port"
#ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=20,arp,nw_dst=10.0.0.2,actions=output:10"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=200,tun_id=20,dl_type=0x0806,nw_dst=10.0.0.2, actions=move:NXM_OF_ETH_SRC[]->NXM_OF_ETH_DST[], mod_dl_src:00:00:00:00:00:02, load:0x2->NXM_OF_ARP_OP[], move:NXM_NX_ARP_SHA[]->NXM_NX_ARP_THA[], move:NXM_OF_ARP_SPA[]->NXM_OF_ARP_TPA[], load:0x000000000002->NXM_NX_ARP_SHA[], load:0x0a000002->NXM_OF_ARP_SPA[],in_port"
ovs-ofctl add-flow -O OpenFlow13 br0 "table=1,priority=100,actions=drop"
