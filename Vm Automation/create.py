#################################################
# Python Imports                                #
#################################################
from __future__ import print_function
import os, uuid
import argparse
import json

import vm_manager
#################################################
# Docker Imports                                #
#################################################


##################################################################################################
# Main Function To Run all Required Process                                                      #
##################################################################################################
if __name__ == "__main__":
    # creation and parsing of command line arguements
    parser = argparse.ArgumentParser(description='Setting Up VMs On AWS EC2 And Azure ')
    parser.add_argument('--file', '-f', help='Used To Specify Configuration File', dest='filename', default="config.json")
    parser.add_argument('--retry', '-r', help="Retry Failed VM's", dest='retry', default=False, action="store_true")
    args = parser.parse_args()
    # opening the config file and reading it in
    vm_list = []
    try:
        with open(args.filename) as json_file:
            obj = json.load(json_file)
            vm_list = obj['vm_list']
    except:
        print(f'Unable To Properly Load The Configuration File {args.filename}\nAborting...')
        exit(0)

    # Creating The virtual machine manager
    vm_manager = vm_manager.VM_Manager()
    vm_manager.do_the_vms(vm_list, args.retry)
