import json
import urllib2
from collections import OrderedDict

from boto3 import Session


def connect():
    response = urllib2.urlopen("http://169.254.169.254/latest/dynamic/instance-identity/document").read()
    response = json.loads(response)

    session = Session(region_name=response['region'])
    ec2 = session.client('ec2')

    return ec2


def find_my_details(ec2):
    instance_id = urllib2.urlopen("http://169.254.169.254/latest/meta-data/instance-id").read()
    private_ip = urllib2.urlopen("http://169.254.169.254/latest/meta-data/local-ipv4").read()

    response = ec2.describe_instances(
        InstanceIds=[
            instance_id,
        ],
    )
    vpc_id = response['Reservations'][0]['Instances'][0]['VpcId']

    properties = {
        'private_ip': private_ip,
        'vpc_id': vpc_id
    }

    return properties


def find_neighbours(ec2, my_properties):
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': 'tag:BIRD',
                'Values': [
                    'True',
                ]
            },
            {
                'Name': 'tag:strongSwan',
                'Values': [
                    'True',
                ]
            },
            {
                'Name': 'vpc-id',
                'Values': [
                    my_properties['vpc_id'],
                ]
            }

        ],
    )

    neighbours = OrderedDict()
    for reservation in response['Reservations']:
        instance = reservation['Instances'][0]
        if instance['PrivateIpAddress'] != my_properties['private_ip']:
            neighbours[instance['InstanceId']] = OrderedDict()
            neighbours[instance['InstanceId']]['private_id'] = instance['PrivateIpAddress']
            for tags in instance['Tags']:
                if tags.get('Key') == 'ASN':
                    neighbours[instance['InstanceId']]['ASN'] = tags['Value']

    return neighbours


ec2 = connect()
my_properties = find_my_details(ec2)
config = find_neighbours(ec2, my_properties)

with open('/tmp/bgp_neighbours.json', 'w') as f:
    f.write(json.dumps(config))