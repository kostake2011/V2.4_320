#!/bin/bash

#chmod u+x /home/pi/printer_data/config/script/update_mcu.sh

#mkdir ~/firmware

#sudo service klipper stop

cd ~/klipper
make clean
#make menuconfig KCONFIG_CONFIG=/home/pi/printer_data/config/script/config.manta723.CAN
make -j4 KCONFIG_CONFIG=/home/pi/printer_data/config/script/config.octopus.CAN
mv ~/klipper/out/klipper.bin ~/firmware/octopus_klipper.bin

make clean
#make menuconfig KCONFIG_CONFIG=/home/pi/printer_data/config/script/config.ebb36.CAN
make -j4 KCONFIG_CONFIG=/home/pi/printer_data/config/script/config.ebb36.CAN
mv ~/klipper/out/klipper.bin ~/firmware/ebb36_klipper.bin

cd ~/katapult/scripts
# Update MCU Manta M8P
echo "Start update MCU Octopus"
echo ""
python3 flash_can.py -i can0 -u 499af335864e -f ~/firmware/octopus_klipper.bin
python3 flash_can.py -f ~/firmware/octopus_klipper.bin -d /dev/serial/by-id/usb-katapult_stm32h723xx_15002D000D51313339373836-if00
sleep 2
read -p "MCU Manta M5P firmware flashed, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"
echo "Finish update MCU octopus"

# Update MCU EBB36
echo "Start update MCU EBB36"
echo ""
python3 flash_can.py -i can0 -u ec339e8549cd -f ~/firmware/ebb36_klipper.bin
sleep 2
#read -p "MCU EBB36 firmware flashed, please check above for any errors. Press [Enter] to continue, or [Ctrl+C] to abort"
echo "Finish update MCU EBB36"

echo ""

#sudo service klipper start
