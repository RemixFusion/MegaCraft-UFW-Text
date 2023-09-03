# UFW Script for TCPShield/Remixed

These scripts are designed to replace the default behavior of TCPShield's IPSet and utilize UFW (IPTables wrapper) Firewall instead. When UFW and IPSet are enabled, IPSet does not take prescident, requiring a UFW rule to allow access to backend servers. While UFW can be configured to only allow from appropriate IP addresses to these backends, this script will automatically handle creating that ruleset and updating it regularly. You do not need IPSet with this script.

## Configuration
Download the tcpshield.sh file and place it in a directory on your server.

Run the following command to make the file executable:
```
chmod u+x tcpshield.sh
```

Test the script by running ./tcpshield (You may want to run it twice and check ufw status to ensure rules are still present)

Create a Cron if you wish to automatically update the list periodically.

### Cron
To automatically update your ruleset, you can use a Cron job to accomplish the task. The cron listed below will check every four hours for changes against TCPShields IP list. If you wish to check hourly, you can change the cron to ```0 */1 * * *```. 

Ubuntu: ```crontab -e``` then select your text editor of choice. At the bottom of the list, below the last #, enter the following:
```0 */4 * * * /location/to/stored/tcpshield.sh```

![alt text](https://github.com/RemixFusion/Minecraft-Proxy-Protocol-UFW-Ruleset/blob/main/crontab.png?raw=true)

Change /location/to/stored/tcpshield.sh to the path of the tcpshield.sh script you downloaded earlier. This is most commonly stored in /home/your-username or /root, unless you were in a particular directory when you downloaded the script. You can always move the file to another location, such as /usr/local/tcpshield.sh. Make sure you re-run the executable command if you rename/move the file.

### Storage
By default, the script will fetch and store the IP List from TCPShield and store it at ```/usr/local/tcpshield.txt```. You can change this in the tcpshield.sh file if you'd rather use a different directory. We also encourage using /usr/local for storage of the .sh files, though this can be changed too. Please make sure to update any locations in both the .sh file and in your cron.
