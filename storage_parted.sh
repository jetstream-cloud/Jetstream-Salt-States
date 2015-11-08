#! /bin/bash
# This should lay out ~49GB partitions for journals on the storage nodes raid 0 ssd drives
# It assumes that the root partition was created in kickstart with the following:
# part / --fstype=xfs --size=100000

parted /dev/sda mkpart extended 105GB 399GB
parted /dev/sda mkpart logical 105GB 154GB
parted /dev/sda mkpart logical 154GB 203GB
parted /dev/sda mkpart logical  203GB 252GB
parted /dev/sda mkpart logical  252GB 301GB
parted /dev/sda mkpart logical  301GB 350GB
parted /dev/sda mkpart logical  350GB 399GB
