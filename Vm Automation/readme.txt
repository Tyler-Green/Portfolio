0977966
Tyler Green

To run
install requirements from requirements.txt
python3 create.py -f <config.json> -r
-r is if you wish to retry failed vm creation
-f is the name of the config file config.json by default

Format For Config File JSON Objects
AWS Objects
{
    "provider": "AWS",
    "id": "001",
    "image": "Ubuntu",
    "instance": "t2.micro",
    "count": 1,
    "keyPair": "test",
    "storage":
        [
            {
                "id":"test",
                "device":"h",
                "encrypted":false,
                "size":8,
                "type":"standard"
            }
        ],
    "docker":
        ["docker image"]
}

Required Feilds
provider - The proveder the Vm is with AWS
id - a unique id to correspond to error messages
Image - typer of image wanted [Amazon Linux 2, Amazon Linux, SUSE, Ubuntu, Red Hat]\
instancescount - number of instances wanted
keyPair - key pair for vm

Optional Feilds
stoarage - list of storage devices
docker - list of docker images

Required In storage
device - the location where to storage volume will be attached
if volume exists
id - identification of existing volume
if volume needs to be created
either size of snapshot
type - type of volume

Azure Object

{
    "provider":"Azure",
    "id":"002",
    "name":"TestVM",
    "resource-group":"ass1",
    "image":"Ubuntu 16",
    "user":"azureuser",
    "password":"PasswordAzure1!",
    "size":"Standard_B1ls",
    "storage":
      [
          {
              "size":8,
              "name":"testingS",
              "type":"Standard_LRS"
          }
      ],
    "docker":
      ["Docekr image"]
}

Required Feilds
provider - provider for vm Azure
id - unique id for vm for error messages
name - name for the vm
resource-group - resource group for the vm
images - image name for vm [Ubuntu, Debian, RHEL]
size - size of instance

optional Feilds
user - username for root
password - password for root
storage - storage volumes
docker - list of docker images

feidls for stoarage
size - size in gb of volume (required if name does not exist)
name - name of volume (required)
type - type of volume (required if name does not exist)

The file can be created using any text editor or using https://jsoneditoronline.org to verify the format of the objects
