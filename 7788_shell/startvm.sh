#!/bin/bash
for Vboxname in `vboxmanage list vms|awk -F'[""]' '{print $2}'`
do
        vboxmanage startvm   $Vboxname  --type headless 

sleep 3
done
