# Setup

Run the ansible playbook and home assistant will be deployed.

## Short description

- Home Assistant (the core container) runs as a Docker Compose service to manage local smart‑home devices, automations and integrations.
- HACS (Home Assistant Community Store) will be deployed/configured automatically via Ansible so community integrations and themes can be installed and kept up to date.
- The setup keeps the HA container lightweight and uses the host system for discovery and direct device access where needed.

## Helpful links

- [Home Assistant (official)](https://www.home-assistant.io/)
- [Docker installation (official)](https://www.home-assistant.io/installation/docker/)
- [HACS (official)](https://hacs.xyz/)
- [Home Assistant docs (Deutsch)](https://www.home-assistant.io/de/)
- [German community (Forum)](https://community.home-assistant.io/c/deutsch/)
- [Simon42 (hands‑on articles and guides)](https://simon42.com/)

## Note about network_mode

Host networking gives Home Assistant direct access to the host network stack (multicast/DNS/UPnP/zeroconf) and local hardware (e.g., Zigbee/Z‑Wave USB sticks). Many integrations rely on multicast discovery or raw socket access that does not work reliably behind an overlay network like {{ docker.external_network }}. Using `network_mode: host` preserves discovery and device access without complex proxy or extra network setup.
