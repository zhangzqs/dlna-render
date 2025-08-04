#!/bin/sh

if [ -z "$UPNP_DEVICE_NAME" ]; then
 UPNP_DEVICE_NAME="DLNA-Render-$(hostname)"
fi

gmediarender -f "$UPNP_DEVICE_NAME" --logfile=stdout
