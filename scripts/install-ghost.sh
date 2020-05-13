#!/bin/bash
set -e

echo "Installing Ghost with Docker Compose ..."

useradd --system --home /etc/ghost.d --shell /bin/false ghost
usermod -aG docker ghost

mkdir --parents /opt/caddy
mkdir --parents /opt/ghost/content
mkdir --parents /etc/ghost.d

if [ $INLETS_PRO == "true" ]; then
cat - > /etc/ghost.d/docker-compose.yaml <<'EOF'
version: '3.2'
services:
  ghost:
    image: ghost:3.14.0-alpine
    restart: always
    volumes:
      - "/opt/ghost/content:/var/lib/ghost/content"
    environment:
      url: "https://${GHOST_DOMAIN}"
  caddy:
    image: caddy:2.0.0-alpine
    command: [
      "caddy",
      "reverse-proxy",
      "--from",
      "${GHOST_DOMAIN}",
      "--to",
      "http://ghost:2368"
    ]
    restart: always
    volumes:
      - "/opt/caddy:/data/caddy"
  inlets:
    image: inlets/inlets-pro:0.6.1
    restart: always
    command: [
      "client",
      "--connect", "${INLETS_REMOTE}",
      "--token", "${INLETS_TOKEN}",
      "--license", "${INLETS_LICENSE}",
      "--tcp-ports", "80,443"
    ]
EOF
else
cat - > /etc/ghost.d/docker-compose.yaml <<'EOF'
version: '3.2'
services:
  ghost:
    image: ghost:3.14.0-alpine
    restart: always
    volumes:
      - "/opt/ghost/content:/var/lib/ghost/content"
    environment:
      url: "${GHOST_URL}"
  inlets:
    image: inlets/inlets:2.7.0
    restart: always
    command: [
      "client",
      "--remote", "${INLETS_REMOTE}",
      "--token", "${INLETS_TOKEN}",
      "--upstream", "http://ghost:2368"
    ]
EOF
fi

chown --recursive ghost:ghost /opt/caddy
chown --recursive ghost:ghost /opt/ghost
chown --recursive ghost:ghost /etc/ghost.d

cat - > /etc/systemd/system/ghost.service <<'EOF'
[Unit]
Description=ghost service with docker compose
Requires=docker.service
After=docker.service
ConditionFileNotEmpty=/etc/ghost.d/ghost.env

[Service]
Type=oneshot
User=ghost
Group=ghost
EnvironmentFile=/etc/ghost.d/ghost.env
RemainAfterExit=true
WorkingDirectory=/etc/ghost.d
ExecStart=/usr/local/bin/docker-compose up -d --remove-orphans
ExecStop=/usr/local/bin/docker-compose down

[Install]
WantedBy=multi-user.target
EOF

systemctl enable ghost.service

echo "============================= Ghost with Docker Compose installation done"