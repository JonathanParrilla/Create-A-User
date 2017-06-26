#!/bin/bash

# ===== Environment Variables ===== 
# SET THESE BEFORE YOU RUN THE SCRIPT ON A SERVER
USER="<Desired User>"
PASSWORD="<Desired Password>"
KEY="User's Public SSH Key (id_rsa.pub)"

# ===== Create The Desired User =====
echo "Creating $USER User"
sudo adduser $USER --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
echo "$USER:$PASSWORD" | sudo chpasswd

# ===== Set Up SSH Access for the Desired User =====
# Become the Desired User and Run commands as the Desired User until you hit EOC (End of Commands)
echo "SU as $USER"
echo "$PASSWORD" | sudo su $USER << EOC

echo "Going into $USER Home Dir."
cd /home/$USER/

echo "Creating .ssh directory"
mkdir .ssh

echo "Modifying .ssh to 700"
chmod 700 .ssh

echo "Creating authorized_keys file for $USER User"
echo "----------"
echo "$KEY" > .ssh/authorized_keys
echo "----------"

echo "Modifying authorized_keys to 600"
chmod 600 .ssh/authorized_keys 
EOC

# ===== SUDO Access for the Desired User =====
# Add the Desired User to list of Sudoers and to the Sudoers File. They will no longer require a password to become root user.
echo "Adding $USER user to sudoers"
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee --append /etc/sudoers
