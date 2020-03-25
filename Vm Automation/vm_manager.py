#################################################
# Python Imports                                #
#################################################
from __future__ import print_function
import os, uuid
import json
import subprocess

import aws
import azure

##################################################################################################
# Class To Control Basic VM Creation                                                             #
##################################################################################################
class VM_Manager:

#################################################
# Function To Initailize The VM_Manager         #
#################################################
    def __init__(self):
        print("Initializing VM Manager")
        self.aws = aws.AWS()
        self.azure = azure.Azure()

        #create a azure manager
        #create lists for vm tracking

#################################################
# Function To Do The VM Management              #
#################################################
    def do_the_vms(self, vm_list, retry):
        for vm_spec in vm_list:
            self.create_vm(vm_spec)
        if retry:
            self.retry_failed()
        self.wait_for_creation()
        self.create_storage()

#################################################
# Function To Facilitate The Creation Of One VM #
#################################################
    def create_vm(self, vm_spec):
        print(f'Attempting To Create VM')
        created = False
        try:
            vm_spec["provider"]
        except:
            print(f'No Provider Specified For Object {vm_spec}\nVM Failed To Create\n')
            return
        #try:
        if vm_spec["provider"] == 'AWS':
            created = self.aws.create_vm(vm_spec)
        elif vm_spec["provider"] == 'Azure':
            created = self.azure.create_vm(vm_spec)
        else:
            print(f'Unknown Provider: {vm_spec["provider"]}')
#        except:
#            print(f'Oopsie Woopsie Something Went Fucky Wucky')
        if created:
            print(f'VM Created Succesfully\n')
        else:
            print(f'VM Failed To Create\n')

#################################################
# Function To Retry The Failed VM creation      #
#################################################
    def retry_failed(self):
        self.aws.retry_failed()
        self.azure.retry_failed()

#################################################
# Function To Wait For VM creation              #
#################################################
    def wait_for_creation(self):
        self.aws.wait_for_creation()
        # note azure is blocking where aws is non blocking in creating of vms

#################################################
# Function To Attach Volume To VM               #
#################################################
    def create_storage(self):
        self.aws.attach_volume()
        self.azure.attach_volume()
