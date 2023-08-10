# Hyper-V Migration
Steps to migrate Hyper-V VM into a Proxmox VM.

## Windows 10
To convert a Windows 10 VM you will need:
- Windows 10 Installation ISO
- Virtio-win ISO
- Upload both to Proxmox storage

### Get Hyper-V VHD
To get started, on the Hyper-V Server you will need to get the Virtual Hard Disk (`.vhdx` or `.vhd`) from the VM you want to export.

You can stop the VM and copy the VHD or you can export the VM, generating a copy of the VM files, and get the VHD from there.

> **_NOTE:_** If a VM has checkpoints the VHD in use could be an Automatic Virtual Hard Disk (`.avhdx` or `.avhd`), this is essentially a differencing disk that's a child of the main VHD. To solve this you can delete the checkpoints, making the Disk files to start merging, or you can merge them manually, either way you will need to let it finish.
<br>
To manually merge Disk files, on the Hyper-V Server click `Edit Disk`, select the AVHD and choose `Merge` (to Parent VHD).

### Create Promox VM
Now you need to transfer the VHD to the proxmox server, you can use whatever method you prefer.

Meanwhile on Proxmox a new VM needs to be created, click `Create VM` and fill in the settings (some settings are only shown by checking `Advanced`):
> **_NOTE:_** Depending on the type of BIOS (`Legacy` or `UEFI`) used on Hyper-V some settings change.
-  General
    - VM ID - `change if needed`
    - Name - `name of the VM`
    - Start at boot - `check if needed`
- OS
    - ISO image - `choose the Win10 ISO`
    - Type - `choose Microsoft Windows`
    - Version - `choose 10/2016/2019`
- System
    - Machine - `choose q35`
    - BIOS - `SeaBIOS for Legacy or OVMF for UEFI`
    - EFI Storage - `choose storage` :warning:`only for UEFI`:warning:
    - SCSI Controller - `VirtIO SCSI`
    - Qemu Agent - `check this`
- Disks
    - scsi0 - `delete, the disk will be imported`
- CPU
    - Sockets - `set for what is needed`
    - Cores - `set for what is needed`
- Memory
    - Memory - `set for what is needed`
    - Minimum memory - `set for wanted, only if ballooning active`
    - Ballooning - `check if wanted`
- Network
    - Model - `choose VirtIO (paravirtualized)`
- Confirm
    - Finish - `click the button to create the VM`

### Handle Transfered VHD
With the VM created, the transfered VHD can now be imported to it.

For that, in the Proxmox shell run:
```
qm importdisk <vmid> <path to VHD> <storage>
```
Something like this:
```
qm importdisk 100 /media/win10.vhdx local-lvm
```

It will take some time, but after finishing go to the VM and change some `Hardware`.

The imported disk will appear as `Unused Disk`, double click it and as `Bus/Device` choose `SCSI for Legacy and VirtIO Block for UEFI`, then click add.

In the same screen, click `Add` a `CD/DVD Drive`, select the `Virtio-win ISO` and add.

Run the VM, there's two ways to do this step (in the VM `Options` adjust the `Boot Order` accordingly to what you choose):
1. Boot from Windows 10 ISO, what for it to boot, select language options and then click `Repair your computer`, wait for the blue screen with `Troubleshoot` option.
2. Let the VM try to boot from the `Disk`, it will restart and eventually it will says it can't boot and give you a blue screen to choose keyboard language, select it, wait for the blue screen with `Troubleshoot` option.

Click `Troubleshoot`, then `Command Prompt` (if this option doesn't show, click `Advanced options` and it should be there).

Run the command `wmic logicaldisk get deviceid, volumename, description`, this will show you all available drives, but it will not show the imported VHD.

See which drive contains the `Virtio-win ISO`, it should be `D:\`, and run `drvload d:\vioscsi\w10\amd64\vioscsi.inf`, this will load the virtio-scsi driver.

Again, run `wmic logicaldisk get deviceid, volumename, description`, this will now show all the drives even from the imported disk.

There should be a `C:\` that is the `Reserved System` partition, so the main `Windows` partition should be the next newly added drive `F:\` (`D:\` being the Virtio ISO and `E:\` being the Windows ISO).

Inject the virtio-scsi driver into the `Windows` installation, run `dism /image:f:\ /add-driver /driver:d:\vioscsi\w10\amd64\vioscsi.inf`, wait for the utility to terminate adding the driver, if the drive is not the main `Windows` partition the utility will throw an error.

Exit the `Command Prompt` and back on the blue screen with the `Troubleshoot` option, there should now be a `Continue to Windows` option, click it to boot Windows, if not reboot the VM and let it boot from the disk.

After the Windows boots up, go to the `Device Manager` and install the missing drivers and the `Qemu-Agent`.

> TODO: Specify drivers installation and add images to the instructions.

All should be good now, don't forget that if you previously had specific network settings they are lost due to the network interface being a new one.