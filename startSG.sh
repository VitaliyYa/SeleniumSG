#!/bin/bash
cd ~/SeleniumSG
gnome-terminal -x sh -c "java -jar selenium-server-standalone-3.141.0.jar -role hub -hubConfig hubConfig.json; bash"
sleep 2
gnome-terminal -x sh -c "java -jar selenium-server-standalone-3.141.0.jar -role node -nodeConfig chromeNodeConfig.json; bash"
gnome-terminal -x sh -c "java -jar selenium-server-standalone-3.141.0.jar -role node -nodeConfig chromeNodeConfig.json; bash"
gnome-terminal -x sh -c "java -jar selenium-server-standalone-3.141.0.jar -role node -nodeConfig firefoxNodeConfig.json; bash"
gnome-terminal -x sh -c "java -jar selenium-server-standalone-3.141.0.jar -role node -nodeConfig firefoxNodeConfig.json; bash"
