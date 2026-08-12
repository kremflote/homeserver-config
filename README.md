# Pi Homeserver

Public configuration snapshot for my personal Raspberry Pi homeserver.

This repository is mainly for documentation, version control, and showcase purposes. It contains selected Docker Compose files, scripts, and examples that describe how the homeserver is put together.

## Overview

The homeserver runs on a Raspberry Pi 4 using Docker Compose. It is accessed through Tailscale, with DNS managed in Cloudflare and web routing handled by Nginx Proxy Manager.

Services:

- Core infrastructure and reverse proxy
- File sync and personal cloud storage with Nextcloud
- Media automation with Sonarr, Radarr, Prowlarr, Bazarr, qBittorrent, and Gluetun
- Media serving with Jellyfin
- Request/discovery frontend with Seerr
- Monitoring with Uptime Kuma and Beszel
- Dashboarding with Homepage
- Personal tools such as Firefly III, Vikunja, and custom [Matflote](https://github.com/kremflote/Matflote) services
- Local backup script using Restic
 
