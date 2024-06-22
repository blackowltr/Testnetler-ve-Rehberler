# Guide to Setting Up a Hetzner Server with Ubuntu

1. **Access the Purchased Server**
   - Navigate to your Hetzner servers and select the server you purchased.

2. **Activate the Rescue System**
   - Activate the rescue system. Save the provided password as you will need it during the initial connection.

3. **Shut Down the Server**
   - Select the "Press power button of server" option and click "Send" to shut down the server.

4. **Restart the Server**
   - Similarly, restart the server.

5. **Connect to the Server**

6. **Run the Installimage Script**
   - After connecting to the server, run the `installimage` script, which allows easy installation of Hetzner-developed Linux distributions.

   ```bash
   installimage
   ```

7. **Select the Linux Distribution**
   - Choose "ubuntu" from the list of available Linux distributions.

8. **Select Ubuntu Version**
   - Select the "ubuntu 2004-focal-64-minial" version.

9. **Configure RAID**
   - In the configuration screen, set "SWRAID 1" and "SWRAIDLEVEL 0".

10. **Modify Partition Settings**
    - Remove the `#` symbols in the `PART /boot` and `lvm` sections. Adjust the `LV` sections as specified.

11. **Delete Unnecessary Section**
    - Delete the specified section as directed.

12. **Save Configuration**
    - Press `F10` to save your changes and select "Yes" to confirm.

13. **Reboot the Server**
    - After saving the changes, reboot the server.

   ```bash
   reboot
   ```

14. **Verify Disk Configuration**
    - Once the server restarts, check if the disks are configured correctly using the `df -h` command.

15. **Update Linux**
    - Perform the necessary Linux updates.

   ```bash
   sudo apt-get update
   sudo apt-get install software-properties-common
   sudo add-apt-repository universe
   ```

16. **Configure DNS Server**
    - Edit the DNS server settings.

   ```bash
   nano /etc/resolv.conf
   ```

17. **Add Google DNS Servers**
    - Add the Google DNS servers as shown.

18. **Install Firewall**
    - Install the firewall.

   ```bash
   sudo apt-get install ufw
   ```

19. **Edit Firewall Configuration**
    - Check the file contents in the `ufw` folder.

   ```bash
   nano /etc/default/ufw
   ```

20. **Open Necessary Ports**
    - Enable the firewall and open the necessary ports.

   ```bash
   sudo ufw enable
   sudo ufw default allow outgoing
   sudo ufw allow ssh
   sudo ufw allow 22/tcp
   sudo ufw allow 2222/tcp
   sudo ufw allow ftp
   sudo ufw allow 20/tcp
   ```

21. **Change Root Password (Optional)**
    - If you want to change the server root password, use the following command:

   ```bash
   passwd root
   ```

22. **Reboot the Server**
    - After completing all the steps, reboot the server.

   ```bash
   reboot
   ```
