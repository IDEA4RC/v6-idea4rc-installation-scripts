#! /bin/bash
SCRIPT_DIR=$(realpath "$(dirname "$0")")
COMMAND=$1
NODE_NAME=$2

source $SCRIPT_DIR/utils.sh

if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
fi


print_header "$COMMAND the vantage6-node"
# print_step "Checking if conda is installed"
# if ! check_command "conda"; then
#     print_error "Did you run the installation script? Exiting..."
#     exit 1
# fi

# print_step "Checking if the vantage6 environment exists"
# if ! check_env "vantage6"; then
#     print_error "Did you run the installation script? Exiting..."
#     exit 1
# fi

print_step "Activating the vantage6 environment"
source $HOME/miniconda/bin/activate vantage6

# start the node
print_step "$COMMAND the $NODE_NAME node"
v6 node $COMMAND --name $NODE_NAME
print_step "Done"