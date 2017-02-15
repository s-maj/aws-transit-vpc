import json
import urllib2
from collections import OrderedDict

from boto3 import Session
from xmldict import xml_to_dict


def get_regions():
    regions_list = []
    current_region = Session()._session.get_config_variable('region')
    session = Session(region_name=current_region)
    ec2 = session.client('ec2')
    regions = ec2.describe_regions()
    for region in regions['Regions']:
        regions_list.append(region['RegionName'])

    return regions_list


def get_vpn_config(regions, public_ip):
    global_config = OrderedDict()
    mark = iter(range(100, 4000, 100))
    for region in regions:
        print("Looking in %s" % region)
        session = Session(region_name=region)
        ec2 = session.client('ec2')

        response = ec2.describe_vpn_connections(
            Filters=[
                {
                    'Name': 'tag:BIRD',
                    'Values': [
                        'True',
                    ]
                },
                {
                    'Name': 'tag:ID',
                    'Values': [
                        public_ip,
                    ]
                },
                {
                    'Name': 'state',
                    'Values': [
                        'available'
                    ]
                }
            ]
        )
        local_config = parse_vpn_response(response, mark)
        global_config.update(local_config)

    return global_config


def parse_vpn_response(response, mark):
    config = OrderedDict()
    for connection in response['VpnConnections']:
        vpn_id = connection['VpnConnectionId']
        config[vpn_id] = OrderedDict()
        vpn_config = xml_to_dict(connection['CustomerGatewayConfiguration'])

        for index, tunnel in enumerate(vpn_config['vpn_connection']['ipsec_tunnel']):
            tunnel_key = 'tunnel-%s' % index
            config[vpn_id][tunnel_key] = OrderedDict()

            config[vpn_id][tunnel_key]['right_inside_ip'] = '%s/%s' % (
                tunnel['customer_gateway']['tunnel_inside_address']['ip_address'],
                tunnel['customer_gateway']['tunnel_inside_address']['network_cidr'])
            config[vpn_id][tunnel_key]['right_outside_ip'] = tunnel['customer_gateway']['tunnel_outside_address'][
                'ip_address']
            config[vpn_id][tunnel_key]['right_asn'] = tunnel['customer_gateway']['bgp']['asn']
            config[vpn_id][tunnel_key]['left_inside_ip'] = '%s/%s' % (
                tunnel['vpn_gateway']['tunnel_inside_address']['ip_address'],
                tunnel['vpn_gateway']['tunnel_inside_address']['network_cidr'])
            config[vpn_id][tunnel_key]['left_outside_ip'] = tunnel['vpn_gateway']['tunnel_outside_address'][
                'ip_address']
            config[vpn_id][tunnel_key]['left_asn'] = tunnel['vpn_gateway']['bgp']['asn']
            config[vpn_id][tunnel_key]['psk'] = tunnel['ike']['pre_shared_key']
            config[vpn_id][tunnel_key]['mark'] = next(mark)

    return config


public_ip = urllib2.urlopen("http://169.254.169.254/latest/meta-data/public-ipv4").read()
all_regions = get_regions()
config = get_vpn_config(all_regions, public_ip)

print("Writing config file")
with open('/tmp/vpn_conf.json', 'w') as f:
    f.write(json.dumps(config))
