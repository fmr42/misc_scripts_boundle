#!/bin/sh

HOST="127.0.0.1"
PORT=9051
LOCALPORT=9051  # Matters only if HOST is not `localhost`
PASSWORD=""  # Better leave it empty

if [ -z "$PASSWORD" ]; then
  echo -n "Tor control password: "
  read -s PASSWORD
  echo
fi

if [ "$HOST" != "127.0.0.1" ]; then
  ssh -f -o ExitOnForwardFailure=yes -L "$LOCALPORT:localhost:$PORT" "$HOST" sleep 1
  PORT="$LOCALPORT"
fi

(
nc 127.0.0.1 "$PORT" <<EOF
authenticate "${PASSWORD}"
signal newnym
quit
EOF
) || echo "Connection failed." >&2

