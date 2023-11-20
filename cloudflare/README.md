# Cloudflare

## Set up ssh connection
Create a cloudflare tunnel to the machine to ssh into.
Set the subdomain, on the service choose SSH as type, fill URL with <IP>:22.

Download cloudflared to the client from where you want to connect.
https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/

Now add the configuration of the ssh connection:
```
nano ~/.ssh/config
```
Add the connection:
```
Host ssh.example.com
  User <user>
  ProxyCommand <path-to-cloudflared> access ssh --hostname %h
```

With this you can access the machine by ssh into the external host.
