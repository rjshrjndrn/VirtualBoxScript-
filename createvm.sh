#!/bin/bash
#atuhor rajesh rajendran
set -e
echo "enter name of the vb"
read name
#for correct os types use this command (gnerally i use Ubuntu and Ubuntu_64)## VBoxManage list ostypes
echo "enter os type"
read os_name
echo "enter hdd size in MB"
read hdd
v_path="~/VirtualBox VMs/$name/$name.vbox"
echo "enter ram size in MB"
read ram
echo "enter the cd image path"
read cd_path
echo "creating new vm $name of os $os_name and hdd size $hdd and ram of $ram"
echo -e "\n\n\t continue y/n"
read flag
if [ "$flag" == "n" ]
then
  echo "$hdd_path"
  exit 0
fi
#creating and reegistering the vm
VBoxManage createvm --name $name --register
#create hdd of size $hdd
VBoxManage createhd --filename ~/VirtualBox\ VMs/$name/disk.vdi --size $hdd 
exit 0
#assigning os type to $os_name
VBoxManage modifyvm $name --ostype $os_name
#assigning ram to $ram
VBoxManage modifyvm $name --memory $ram
#creating storage controller for the virtual machine
VBoxManage storagectl $name --name IDE --add ide --controller PIIX4 --bootable on
#create sata
VBoxManage storagectl $name --name SATA --add sata --controller IntelAhci --bootable on
#attach the created sata to the vm
VBoxManage storageattach $name --storagectl SATA --port 0 --device 0 --type hdd --medium ~/VirtualBox\ VMs/$name/disk.vdi
#attach the storage controller ide with ISO image
VBoxManage storageattach $name --storagectl IDE --port 0 --device 0 --type dvddrive --medium "$cd_path"
#audio 3d accilarator 
#Because its a ubuntu server configuration i disabled audio video and graphics. you can change the values as u desire.
VBoxManage modifyvm $name --vram 1 --accelerate3d off --audio none --audiocontroller hda
#networking
VBoxManage modifyvm $name --nic1 bridged --bridgeadapter1 eth0
#misc tweaking for perfomance and memory management
VBoxManage modifyvm $name --acpi on --boot1 dvd --pae on --ioapic on 

#starting virtual machine !!!
VBoxManage startvm $name

#remote desktop config
#in latest vms (>4.0) the RDP and some other supports are provided as an extension pack. so you've to download the setup and install it using this command
#VBoxManage extpack install name_of_the_extension_pack
##VBoxManage modifyvm $name --vrde on --vrdeport 5012 
#start remote vm Available options are gui / sdl / headless
##VBoxManage startvm $name --type headless
#to access rd
##rdesktop -a 16 -N ip_of_the_host:5012

#to stop the machne
##VBoxManage controlvm $name poweroff

#“controlvm <name> <options>” controlvm command is used to control the state of the virtual machine. <name> defines the name of the virtual machine. Some of the available options are pause / resume / reset / poweroff / savestate / acpipowerbutton / acpisleepbutton. There are many options in controlvm to see all the options available in it. Either type or copy and paste the below command in terminal.
##VBoxManage controlvm
exit 0
