<img src="https://github.com/IKNL/guidelines/blob/master/resources/logos/iknl_nl.png?raw=true" width=200 align="right">

# vantage6 IDEA4RC Installation Scripts

This repository contains convenience scripts for installing vantage6 nodes at data
stations participating in the IDEA4RC project.

## Getting Started
These instructions will get you a running vantage6 node that is connected to the
IDEA4RC server.

### Prerequisites

- The scripts are designed to run on an Ubuntu 22 machine (server edition).
- During installation it requires internet access to download the necessary packages.
- `sudo` permissions (you might get prompted for your password during the installation
  process).
- Install git:
    ```
    sudo apt update -y
    sudo apt install git -y
    ```
- A running instance from the OHDSI API server. During configuration you will be promted
  to provide connection details.
- Make sure docker is installed and the current user is added in the `docker` group.

### Installing
Go to the home directory of the user that has `sudo` permissions and execute the
following steps in `bash`:

```bash
# Clone this repository to your local machine:
git clone https://github.com/IDEA4RC/v6-idea4rc-installation-scripts.git

# Navigate to the cloned repository:
cd v6-idea4rc-installation-scripts.git

# Add execute permissions to the scripts:
chmod +x *.sh

# Run the install-all.sh script:
./install-all.sh
```

### Lifecycle management

The `./install-all.sh` script is designed to run multiple times. You can also use it
to update the vantage6 node to the latest version. It will not overwrite any
configuration files except if you explicitly tell it to do so.

You have the following scripts available to manage the vantage6 node:

- `./start.sh` - Starts the vantage6 node
- `./stop.sh` - Stops the vantage6 node
- `./attach.sh` - View the logs of the vantage6 node if its running
- `./install-all.sh` - Reinstall and reconfigure the vantage6 node

### Debugging

If you see an error during the installation process, first thing is to have a look at
the logs in the `logs` directory. In case the node is not online or responding, you can
use the `attach.sh` script to view the active logs. If you can't figure out what is
going wrong, please reach out to the IKNL vantage6 team.

## License

This project is licensed under the Apache License - see the [LICENSE](LICENSE) file for
details.
