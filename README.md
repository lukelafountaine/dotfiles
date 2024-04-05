# Luke LaFountaine's Dotfiles

TODO: Add documentation about how to install everything.

## Using Tailscale while using corporate VPN

1. Get the IP addresses of the name servers that are used when on your coporate VPN:
   - Make sure Tailscale and your corporate VPN are both off
   - `scutil --dns > normal.txt`
   - Turn on your corporate VPN
   - `scutil --dns > vpn.txt`
   - `diff normal.txt vpn.txt`

2. Add `/etc/resolver/` files for each search domain used by your corporate network:
   - `sudo mkdir /etc/resolver`
   - For each name server found in in step 1:
     - `sudo echo "nameserver <IP FROM PREVIOUS STEP>" >> /etc/resolver/example.org`
   - If some of the `*.example.org` subdomains should be *publicly available* (i.e. you
     should be able to access them when you are *not connected* to the corporate VPN),
     then you may want to add `/etc/resolver/` files for those subdomains and make the
     nameserver the Tailscale DNS IP address- `100.100.100.100`. That way, those
     subdomains will still be handled by Tailscale but DNS requests for the rest of the
     `*.example.org` subdomains will be routed to the private nameservers.

There probably is a better/easier way to do this via Tailscale split DNS but from what
I've tried so far, it hasn't worked like I expected. Here's a resource that seems
promising and might deserve another look:
https://forum.tailscale.com/t/tailscale-and-local-dnsmasq/1480

TODO: Add more detailed explanation of how and why this is needed.
