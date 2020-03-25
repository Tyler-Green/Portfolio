#################################################
# Python Imports                                #
#################################################
from __future__ import print_function
import os, uuid
import json
import subprocess

#################################################
# Azure Imports                                 #
#################################################

##################################################################################################
# Class To Create and Manage Azure VMs                                                           #
##################################################################################################
class Azure:

#################################################
# Function To Initailize The Azure Clients      #
#################################################
    def __init__(self):
        self.spec = {}
        self.instances = {}
        self.retry_list = []

#################################################
# Function To Initailize The Azure VM Instance  #
#################################################
    def create_vm(self, vm_spec):
        valid = self.verify_spec(vm_spec)
        if not valid:
            return False
        command = ['az', 'group', 'exists', '-g', vm_spec['resource-group']]
        resp = subprocess.check_output(command)
        resp.decode('ascii')
        if 'false' == resp:
            command = ['az', 'group', 'create', '-l', 'westus', '-n', vm_spec['resource-group']]
            try:
                subprocess.run(command)
            except:
                print(f'Unable To Create Resource Group')
                if vm_spec not in self.retry_list:
                    self.retry_list.append(vm_spec)
                return False
        command  = 'az vm create'
        for key in vm_spec.keys():
            command = command + Azure.generate_vm_line(key, vm_spec[key])
        try:
            resp = subprocess.check_output(command.split())
        except:
            print(f'Failed To Create Instance For VM With ID:{vm_spec["id"]}')
            if vm_spec not in self.retry_list:
                self.retry_list.append(vm_spec)
            return False
        output_obj = eval(resp.decode('ascii'))
        self.spec[vm_spec['id']] = vm_spec
        self.instances[vm_spec['id']] = output_obj
        docks = []
        try:
            docks = vm_spec['docker']
        except:
            docks = []
        #Azure.install_docker(vm_spec['resource-group'], vm_spec['name'], docks, vm_spec['image'])
        return True

#################################################
# Function To Install Docker To The VM          #
#################################################
    def install_docker(group, name, docks, img):
        cmd = 'echo testing'
        try:
            with open("ami.json") as json_file:
                obj = json.load(json_file)
                cmd = obj['Azure']['image'][img]['docker']
        except:
            print(f'Unable To Properly Load The AMI Specification File: ami.json')
            return False
        for part in cmd.split("&&"):
            command = ['az', 'vm', 'run-command', 'invoke', '-g', group, '-n', name, '--command-id', 'RunShellScript', '--scripts', '"'+part+'"']
            subprocess.run(command)
        for dock in docks:
            command = ['az', 'vm', 'run-command', 'invoke', '-g', group, '-n', name, '--command-id', 'RunShellScript', '--scripts', '"sudo docker pull '+dock+'"']
            subprocess.run(command)



#################################################
# Function To Verify The Azure VM Specification #
#################################################
    def verify_spec(self, vm_spec):
        attributes = ['id', 'name', 'resource-group', 'image', 'user', 'password']
        valid = True
        for attr in attributes:
            try:
                vm_spec[attr]
            except:
                valid = False
                print(f'Missing Attribute: {attr}')
        if Azure.get_image(vm_spec['image']) is None:
            return False
        try:
            size = vm_spec['size']
            valid = verify_vm_size(size)
            if not valid:
                print(f'Size {size} Is Not Valid')
                return False
        except:
            return valid
        return valid

#################################################
# Function Generate Vm Create Command Lines     #
#################################################
    def generate_vm_line(key, value):
        line = ''
        if key == 'name':
            line = ' --name ' + value
        elif key == 'resource-group':
            line = ' --resource-group ' + value
        elif key == 'image':
            line = ' --image ' + Azure.get_image(value)
        elif key == 'user':
            line = ' --admin-username ' + value
        elif key == 'password':
            line = ' --admin-password ' + value
        elif key == 'size':
            line = ' --size ' + str(value)
        return line

#################################################
# Function Get VM image URN                     #
#################################################
    def get_image(img_name):
        img_urn = None
        try:
            with open("ami.json") as json_file:
                obj = json.load(json_file)
                azure_img_list = obj['Azure']['image']
        except:
            print(f'Unable To Properly Load The AMI Specification File: ami.json')
            return img_urn
        try:
            img_urn = azure_img_list[img_name]['urn']
        except:
            print(f'Unable To Find Image Urn For {img_name}')
        return img_urn

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
# Function To Attach Volume To Instance         #
#################################################
    def attach_volume(self):
        for key in self.instances.keys():
            instance = self.instances[key]
            vm_spec = self.spec[key]
            for volume in vm_spec['storage']:
                valid = Azure.verify_volume(vm_spec, volume)
                if not valid:
                    print(f'Unable To Create Or Attach Some Storage')
                else:
                    #check if Exists
                    id = Azure.volume_id(volume['name'], vm_spec['resource-group'])
                    command = ""
                    if id is None:
                        command = "az vm disk attach --new"
                        for key in volume.keys():
                            command = command + Azure.generate_volume_line(key, volume[key])
                        command = command + Azure.generate_volume_line('vm_name', vm_spec['name'])
                        command = command + Azure.generate_volume_line('resource-group', vm_spec['resource-group'])
                    else:
                        command = "az vm disk attach -g "+vm_spec['resource-group']+" --vm-name "+vm_spec['name']+" --name "+id
                    try:
                        resp = subprocess.check_output(command.split())
                    except:
                        print(f'Unable To Attach Volume {volume["name"]} To VM With Id {vm_spec["id"]}')

#################################################
# Function Generate Vm Create Command Lines     #
#################################################
    def generate_volume_line(key, value):
        line = ''
        if key == 'name':
            line = ' --name ' + value
        elif key == 'resource-group':
            line = ' -g ' + value
        elif key == 'size':
            line = ' --size-gb ' + str(value)
        elif key == 'vm_name':
            line = ' --vm-name ' + value
        elif key == 'type':
            line = ' --sku ' + value
        return line

#################################################
# Function To Verify Volume Specification       #
#################################################
    def verify_volume(vm_spec, volume):
        attributes = ['name']
        valid = True
        for attr in attributes:
            try:
                volume[attr]
            except:
                print(f'Missing attribute {attr}')
                valid = False
        if not valid:
            return False
        #   check if exists
        id = Azure.volume_id(volume['name'], vm_spec['resource-group'])
        if id is not None:
            return True
        attributes = ['size', 'type']
        for attr in attributes:
            try:
                volume[attr]
            except:
                print(f'Missing attribute {attr}')
                valid = False
        if not valid:
            return False
        return Azure.verify_volume_type(volume['type'])

#################################################
# Function To Check if A Volume Existsin        #
#################################################
    def volume_id(name, group):
        command = ['az', 'disk', 'show', '-n', name, '-g', group, '--query', "'id'", '-o', 'tsv']
        try:
            resp = subprocess.check_output(command)
        except:
            return None
        return resp

#################################################
# Function To Verify A Volume's Type            #
#################################################
    def verify_volume_type(type):
        try:
            with open("ami.json") as json_file:
                obj = json.load(json_file)
                azure_type_list = obj['Azure']['storage-sku']
        except:
            print(f'Unable To Properly Load The AMI Specification File: ami.json')
            return False
        return type in azure_type_list

#################################################
# Function To Verify A VM's size                #
#################################################
    def verify_vm_size(size):
        try:
            with open("ami.json") as json_file:
                obj = json.load(json_file)
                azure_size_list = obj['Azure']['size']
        except:
            print(f'Unable To Properly Load The AMI Specification File: ami.json')
            return False
        return size in azure_size_list
