#################################################
# Python Imports                                #
#################################################
from __future__ import print_function
import os, uuid
import json
import subprocess
import time

#################################################
# AWS Imports                                   #
#################################################
import boto3

ebs_volume_prefix = "/dev/sd"

##################################################################################################
# Class To Create and Manage AWS VMs                                                             #
##################################################################################################
class AWS:

#################################################
# Function To Initailize The AWS Clients        #
#################################################
    def __init__(self):
        self.ec2_client = boto3.client('ec2')
        self.ec2_resource = boto3.resource('ec2')
        self.instances = {}
        self.retry_list = []
        self.spec = {}


#################################################
# Function To Initailize The AWS EC2 Instance   #
#################################################
    def create_vm(self, vm_spec):
        if not AWS.verify_spec(vm_spec):
            return False
        key_path = os.path.join('keys',vm_spec['keyPair']+'.pem')
        if not os.path.exists(key_path):
            try:
                print(f'Creating New Key Pair {vm_spec["keyPair"]}')
                key_pair = self.ec2_resource.create_key_pair(KeyName=vm_spec['keyPair'])
                KeyPairOut = str(key_pair.key_material)
                outfile = open(key_path,'w')
                outfile.write(KeyPairOut)
                outfile.close()
                command = ['chmod', '400', key_path]
                resp = subprocess.run(command)
            except:
                print(f'Failed To Create Key Pair: {vm_spec["keyPair"]}')
        docks = []
        try:
            docks = vm_spec['docker']
        except:
            docks = []
        docker_info = AWS.install_docker(vm_spec['image'], docks)


        instance = []
        try:
            string = self.ec2_client.run_instances(
                ImageId=AWS.get_AMI(vm_spec['image']),
                MinCount=1,
                MaxCount=vm_spec['count'],
                InstanceType=vm_spec['instance'],
                KeyName=vm_spec['keyPair'],
                UserData=docker_info
            )
            for inst in string['Instances']:
                instance.append(self.ec2_resource.Instance(inst['InstanceId']))
        except:
            print(f'Failed To Create Instance For VM With ID:{vm_spec["id"]}')
            if vm_spec not in self.retry_list:
                self.retry_list.append(vm_spec)
            return False
        #check instance creation
        self.instances[vm_spec['id']] = instance
        self.spec[vm_spec['id']] = vm_spec
        for i in instance:
            response = i.modify_attribute(Groups=['sg-0303fd7fb8abaa070'])

        return True

#################################################
# Function To Retry The Failed VM creation      #
#################################################
    def retry_failed(self):
        retry_list = self.retry_list
        for vm_spec in retry_list:
            print(f'Attempting To Retry {vm_spec["id"]}')
            created = self.create_vm(vm_spec)
            if created:
                print(f'VM Created Successfully')
            else:
                print(f'VM Failed To Create For A Second Time\nAborting The Creation Of VM\n')
        self.retry_list = []

#################################################
# Function To Wait For VM creation              #
#################################################
    def wait_for_creation(self):
        for id, instance in self.instances.items():
            for i in instance:
                print(f'Waiting On Vm With Id: {id}')
                i.wait_until_exists()
                i.start()
                i.wait_until_running()
                print(f'{id}:{i} Is Now Running')

#################################################
# Function To Verify The VM Specification       #
#################################################
    def verify_spec(vm_spec):
        result = True
        missing = False
        req_attr = ['id', 'image', 'instance', 'count', 'keyPair']
        for attr in req_attr:
            try:
                vm_spec[attr]
            except:
                print(f'Missing Attribute: {attr}')
                missing = True
        if missing:
            return False
        code = AWS.get_AMI(vm_spec['image'])
        if code is None:
            result = False
        code = AWS.verify_Instance(vm_spec['instance'])
        if code is False:
            print(f'Bad Instance')
            result = False
        return result

#################################################
# Function To Get The AMI Code                  #
#################################################
    def get_AMI(img):
        ami_code = None
        try:
            with open("ami.json") as json_file:
                obj = json.load(json_file)
                aws_ami_list = obj['AWS']['ami']
        except:
            print(f'Unable To Properly Load The AMI Specification File: ami.json')
            return ami_code
        try:
            ami_code = aws_ami_list[img]['ami']
        except:
            print(f'Unable To Find AMI Code For {img}')
        return ami_code

#################################################
# Function To Verify Instance Type              #
#################################################
    def verify_Instance(instance):
        try:
            with open("ami.json") as json_file:
                obj = json.load(json_file)
                aws_ami_list = obj['AWS']['instance']
        except:
            print(f'Unable To Properly Load The AMI Specification File: ami.json')
            return False
        return  instance in aws_ami_list

#################################################
# Function To Attach Volume To Instance         #
#################################################
    def attach_volume(self):
        for id in self.spec.keys():
            print(f'Attaching Volumes To VM With Id {id}\n')
            instance = self.instances[id]
            for i in instance:
                avail_zone = i.placement['AvailabilityZone']
                try:
                    volumes = self.spec[id]['storage']
                except:
                    volumes = []
                for volume in volumes:
                    valid = AWS.check_volume_valid(volume)
                    if not valid:
                        print(f'Volume Is Not Validly Defined')
                    else:
                        exists = self.volume_exists(volume)
                        if not exists:
                            print(f'Volume Does Not Exist\nNew Volume Will Be Created')
                            try:
                                encrypt = volume['encrypted']
                            except:
                                encrypt = True
                            try:
                                type =  volume['type']
                            except:
                                type = 'gp2'
                            try:
                                cmk = volume['cmk']
                                encrypt = True
                            except:
                                cmk = None
                            size = None
                            try:
                                size = volume['size']
                                #either size or snapshot
                            except:
                                try:
                                    snapshot = volume['snapshot']
                                except:
                                    size = 8
                                    response = None
                            if size is None:
                                if cmk is None:
                                    response = self.ec2_client.create_volume(
                                    AvailabilityZone=avail_zone,
                                    Encrypted=encrypt,
                                    SnapshotId=snapshot,
                                    VolumeType=type
                                    )
                                else:
                                    response = self.ec2_client.create_volume(
                                    AvailabilityZone=avail_zone,
                                    Encrypted=encrypt,
                                    KmsKeyId=cmk,
                                    SnapshotId=snapshot,
                                    VolumeType=type
                                    )
                            else:
                                if cmk is None:
                                    response = self.ec2_client.create_volume(
                                    AvailabilityZone=avail_zone,
                                    Encrypted=encrypt,
                                    Size=size,
                                    VolumeType=type
                                    )
                                else:
                                    response = self.ec2_client.create_volume(
                                    AvailabilityZone=avail_zone,
                                    Encrypted=encrypt,
                                    KmsKeyId=cmk,
                                    Size=size,
                                    VolumeType=type
                                    )
                        # create volume
                            volume['id'] = response['VolumeId']
                        # wait for volume Creation
                            waiter = self.ec2_client.get_waiter('volume_available')
                            waiter.wait(VolumeIds=[volume['id']])
                        # attach volume
                            device = ebs_volume_prefix + volume['device']
                            #try:
                            i.attach_volume(Device=device, VolumeId=volume['id'])
                            #except:
                            #    print(f'Unable To Attach Volume {volume["id"]} To Vm With Id {id}\n')

#################################################
# Function Check If Volume Exists               #
#################################################
    def volume_exists(self, volume):
        try:
            volume['id']
        except:
            return False
        resp = None
        try:
            resp = self.ec2_client.describe_volumes(VolumeIds=[volume['id']])
        except:
            return False
        if len(resp['volumes']) > 0:
            return True
        return False

#################################################
# Function Check If Volume Is Valid               #
#################################################
    def check_volume_valid(volume):
        attributes = ['device']
        missing = False
        for attr in attributes:
            try:
                volume[attr]
            except:
                print(f'Volume Misisng {attr} Attribute')
                missing = True
        if volume['device'] < 'f' or volume['device'] > 'p' or missing:
            return False


        size_or_snapshot = False
        check = ['size', 'snapshot']
        for attr in check:
            try:
                volume[attr]
            except:
                if not size_or_snapshot:
                    size_or_snapshot = True
                else:
                    size_or_snapshot = False
        if not size_or_snapshot:
            return False
        try:
            type =  volume['type']
            try:
                volume_types = []
                volume_size = {}
                with open("ami.json") as json_file:
                    obj = json.load(json_file)
                    volume_types = obj['AWS']['volume_types']
                    volume_size = obj['AWS']['volume_size']
                if type not in volume_types:
                    print(f'Unknown Volume Type {type}')
                    return False
                min = volume_size[type]["min"]
                max = volume_size[type]["max"]
                try:
                    size = volume['size']
                except:
                    size = 501
                if min > size:
                    print(f'Volume Size To Small Must Be At Least {min}')
                    return False
                elif max < size:
                    print(f'Volume Size To Large Must Be At Most {max}')
                    return False

            except:
                print(f'Unable To Properly Load The AMI Specification File: ami.json')
                return False
        except:
            return True
        return True

#################################################
# Function To Install Docker In VM              #
#################################################
    def install_docker(image, docks):
        cmd = '#!/bin/bash'
        pkg = ''
        try:
            with open("ami.json") as json_file:
                obj = json.load(json_file)
                pkg = obj['AWS']['ami'][image]['pkg']
        except:
            print(f'Unable To Properly Load The AMI Specification File: ami.json')
            return ''
        cmd = cmd + '\n'+pkg+'\nsudo service docker start'
        for dock in docks:
            cmd = cmd + '\nsudo docker pull '+dock
        return cmd
