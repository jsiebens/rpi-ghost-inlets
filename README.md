# RPI Ghost - Inlets

## How to use this?

1. Start an inlets exit-node with `inlets-pro server` or `inlets server`. For more information, have a look [here](https://docs.inlets.dev/#/?id=exit-servers).
2. Get a domain ready and configure a DNS A record with the public IP address of the exit-node.
3. Download the [latest release](https://github.com/jsiebens/rpi-ghost-inlets/releases).
4. Write the image to an SD card.
5. Customize the /boot/user-data with your domain, inlets exit-node, token and license.
6. Connect a Raspberry Pi to a network and boot with the SD card.
7. Wait for Ghost and Inlets to start. (This could take a moment as your pi will download the required Docker images)
8. Finish configuring Ghost using the admin port.
