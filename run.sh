#!/bin/bash
set -e

IMAGE_NAME="gs16100/team1_project:0.1.0"
CONTAINER_NAME="farm-sim-gui-container"

docker run --rm -it \
  -p 127.0.0.1:6080:6080 \
  -p 127.0.0.1:5900:5900 \
  -v "$(pwd):/workspace" \
  -w /workspace \
  --name "$CONTAINER_NAME" \
  "$IMAGE_NAME" \
  bash -c '
    set -e
    export DISPLAY=:99

    Xvfb :99 -screen 0 1280x800x24 &
    sleep 1

    openbox &
    x11vnc -display :99 -forever -shared -rfbport 5900 -nopw &
    /usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

    chmod +x /workspace/main || true
    exec /workspace/main
  '
