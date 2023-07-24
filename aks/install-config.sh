#!/bin/bash
sudo apt-get update
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
sudo apt-get update
sudo apt-get install azure-cli -y
sudo snap install kubectl --classic