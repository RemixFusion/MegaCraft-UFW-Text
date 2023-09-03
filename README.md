# UFW Script for TCPShield/Remixed

These scripts are designed to replace the default behavior of TCPShield's IPSet and utilize UFW (IPTables wrapper) Firewall instead. When UFW and IPSet are enabled, IPSet does not take prescident, requiring a UFW rule to allow access to backend servers or additional UFW rules specifying access. While UFW can be configured to only allow from appropriate IP addresses to these backends, this script will automatically handle creating that ruleset and updating it regularly. You do not need IPSet with this script.

This will allow you to see the rules in UFW, rather than having to check IPSet or IPTables for the rules. For those utilizing UFW, this will make management easier.

## Configuration
Add a new UFW application called Minecraft and specify the ports to your server.

Download the tcpshield.sh file and place it in a directory on your server.

Run the following command to make the file executable:
```
chmod u+x tcpshield.sh
```

Test the script by running ./tcpshield (You may want to run it twice and check ufw status to ensure rules are still present)

Create a Cron if you wish to automatically update the list periodically.

### UFW Application
Navigate to ```/etc/ufw/applications.d/```

Add a new file ```nano minecraft```

Add the following text:
```
[Minecraft]
  title = "Minecraft"
  description = "Minecraft Java and Bedrock Ports"
  ports = 25565/tcp|19132/udp
```
At this step, it is important that you define the ports of your backend server(s). By default, we allow the default ports for Java (25565/tcp) and Bedrock (19132/udp) Edition. You can continue adding more through adding ```|``` and additional ports/protocols, or take out the existing ```|``` and enter only one port if you are running a Java or Bedrock only server.

Save the configuration. To exit in nano type ```CTRL + X``` followed by ```Y```. 

### Cron
To automatically update your ruleset, you can use a Cron job to accomplish the task. The cron listed below will check every four hours for changes against TCPShields IP list. If you wish to check hourly, you can change the cron to ```0 */1 * * *```. 

Ubuntu: ```crontab -e``` then select your text editor of choice. At the bottom of the list, below the last #, enter the following:
```0 */4 * * * /location/to/stored/tcpshield.sh```

![alt text](https://github.com/RemixFusion/Minecraft-Proxy-Protocol-UFW-Ruleset/blob/main/crontab.png?raw=true)

Change /location/to/stored/tcpshield.sh to the path of the tcpshield.sh script you downloaded earlier. This is most commonly stored in /home/your-username or /root, unless you were in a particular directory when you downloaded the script. You can always move the file to another location, such as /usr/local/tcpshield.sh. Make sure you re-run the executable command if you rename/move the file.

### Storage
By default, the script will fetch and store the IP List from TCPShield and store it at ```/usr/local/tcpshield.txt```. You can change this in the tcpshield.sh file if you'd rather use a different directory. We also encourage using /usr/local for storage of the .sh files, though this can be changed too. Please make sure to update any locations in both the .sh file and in your cron.

### Why does this not specifically allow the port(s) of my Minecraft Server?
While your server will typically listen on port 25565/tcp for Java Edition or 19132/udp for Bedrock Edition, players establish a connection to your server with a random port. BungeeCord allows you to see this with /ip player_name. As a result, we must allow the entirety of the IPs listed, for all ports. You can always fine-tune the ruleset to block access to particular ports if there is a particular need. It should be noted that this mimicks the functionality of IPSet which also allows all ports.

Providers such as TCPShield will often only allow Minecraft traffic to pass, and block other ports used for web servers and other applications which may be hosted on your server. This is not guaranteed, and you may want to check with your provider for specific information.


