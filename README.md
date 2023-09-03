# UFW Script for TCPShield

These scripts are designed to replace the default behavior of TCPShield's IPSet and utilize UFW (IPTables wrapper) Firewall instead. When UFW and IPSet are enabled, IPSet does not take prescident, requiring a UFW rule to allow access to backend servers. While UFW can be configured to only allow from appropriate IP addresses to these backends, this script will automatically handle creating that ruleset and updating it regularly. You do not need IPSet with this script.

## Configuration
Download the tcpshield.sh file and place it in a directory on your server.

Run the following command to make the file executable:
```
chmod u+x tcpshield.sh
```

Test the script by running ./tcpshield (You may want to run it twice and check ufw status to ensure rules are still present)

Create a Cron to automatically run the script at whatever interval you wish.

### Cron
Ubuntu: ```crontab -e```

0 */4 * * * /location/to/stored/tcpshield.sh

0 */4 * * * will run/check every 4 hours. To make it check every hour, you can use 0 */1 * * * .
