# Luke LaFountaine's Dotfiles

## Computer Setup

This is a basic description of my computer setup:

- **Cloud Storage**: After experimenting with a few different services, I landed on Proton
  Drive for cloud storage. I use Proton Mail and am generally pretty happy with it.
- **File Organization**: I have a pretty simple directory structure. I really only have
  five top-level directories in my home folder:
  - `code`: This is where all of my code lives.
  - `data`: This is where temporary data lives. Sometimes I'll be working with a dataset
    that I don't really want sitting around in a repository, constantly making sure that I
    don't commit it, etc. But I also want it around long enough that `/tmp` is not the
    right place for it either.
  - `notes`: This directory is symlinked into my cloud storage directory, so it's backed
    up and accessible across my devices. There are more details on this directory below.
  - `projects`: These are files that I access somewhat frequently. This is where I store
    documents for my long-running responsibilities and other non-code and non-note
    projects.
  - `archive`: This is all of the things that were probably in `projects` at some point
    but haven't been used in a long time. It also contains old files that I'm just not
    ready to throw away yet.
- **Notes**: I keep all of my notes in plain text and mainly use Obsidan for viewing them.
  I also use the Helix text editor which is very convenient for working with Markdown. I
  sync these notes to my phone using Obsidian Sync, and as mentioned above, my `notes`
  directory actually lives in my cloud storage directory. So, my notes are backed up to
  the cloud.
- **Bookmarks**: In the past, I've worked across multiple machines and always found it a
  pain to synchronize bookmarks between machines and browsers. That made me interested in
  looking at different solutions. I tried to use the 1Password browser extensions as a
  bookmark manager, but found that logging into 1Password all the time for non-secret
  things was a pain. So ultimately, I landed on using Tailscale and my own golink service.
  So, across all browsers on all devices that are on my tailnet, I can access my usual
  sites using `go/<short-code>`.

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
