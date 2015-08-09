#! /bin/sh

set -e

[ "$BTSSECRET" ] || BTSSECRET=$(btsync --generate-secret)
if [ ! -d "$SYNCDIR" ]; then mkdir "$SYNCDIR" && chmod 777 "$SYNCDIR"; fi

[ ! -L /.sync ] && ln -sf /btsync /.sync

if [ ! -f /btsync/btsync.conf] && [ "$ENABLE_GUI" = 'noway' ]; then cat > /btsync/btsync.conf <<EOF
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
EOF;
fi

if [ ! -f /btsync/btsync.conf ] && [ "$ENABLE_GUI" = 'way' ]; then cat > /btsync/btsync.conf <<EOF
{
  "device_name": "Sync Server",
  "listening_port": 3369,
  "check_for_updates": false,
  "use_upnp": false,
  "download_limit": 0,
  "upload_limit": 0,
  "webui": {
    "listen": "0.0.0.0:8384",
    "login": "${BTSUNAME}",
    "password": "${BTSPASS}"
  }
}
EOF;
fi

btsync --nodaemon --config /btsync/btsync.conf
bin/bash
