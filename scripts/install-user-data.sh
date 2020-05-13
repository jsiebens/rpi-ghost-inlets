#!/bin/bash
set -e

if [ $INLETS_PRO == "true" ]; then
cat - > /boot/user-data <<'EOF'
#cloud-config
# vim: syntax=yaml
#

hostname: ghost
manage_etc_hosts: true

package_update: false
package_upgrade: false

write_files:
  - path: /etc/ghost.d/ghost.env
    owner: ghost:ghost
    content: |
      INLETS_REMOTE=<your inlets remote>
      INLETS_TOKEN=<your inlets token>
      INLETS_LICENSE=<your inlets license>
      GHOST_DOMAIN=<your ghost domain>
EOF
else
cat - > /boot/user-data <<'EOF'
#cloud-config
# vim: syntax=yaml
#

hostname: ghost
manage_etc_hosts: true

package_update: false
package_upgrade: false

write_files:
  - path: /etc/ghost.d/ghost.env
    owner: ghost:ghost
    content: |
      INLETS_REMOTE=<your inlets remote>
      INLETS_TOKEN=<your inlets token>
      GHOST_URL=<your ghost url>
EOF
fi