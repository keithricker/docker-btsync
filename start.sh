#! /bin/sh

set -e

[ "$BTSSECRET" ] || BTSSECRET=$(btsync --generate-secret)

[ ! -L /.sync ] && ln -sf /btsync /.sync

[ ! -f /btsync/btsync.conf ] && cat > /btsync/btsync.conf <<EOF
{
  "device_name": "Sync Server",
  "listening_port": 3369,
  "check_for_updates": false,
  "use_upnp": false,
  "download_limit": 0,
  "upload_limit": 0,
  "shared_folders": [
    {
      "secret": "${BTSSECRET}",
      "dir": "${SYNCDIR}",
      "use_relay_server": true,
      "use_tracker": true,
      "use_dht": false,
      "search_lan": true,
      "use_sync_trash": false
    }
  ],  
  "webui": {
    "listen": "0.0.0.0:8384",
    "login": "${BTSUNAME}",
    "password": "${BTSPASS}"
  }
}
EOF

btsync --nodaemon --config /btsync/btsync.conf
bin/bash
