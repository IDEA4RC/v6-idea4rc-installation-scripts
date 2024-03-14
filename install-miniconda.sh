#!/bin/bash

# Print the current time and user
source $SCRIPT_DIR/utils.sh
print_info &>> $LOG_DIR/miniconda-install.log

# Check if Miniconda is already installed
print_step "Checking if Miniconda is already installed"
if command -v conda &> /dev/null; then
    print_warning "Miniconda is already installed." | tee -a $LOG_DIR/miniconda-install.log
else

    print_step "Check that curl is installed"
    if ! check_command "curl"; then
        print_warning "Curl not installed. Installing Curl"
        sudo apt install curl -y &>> $LOG_DIR/miniconda-install.log
    fi

    # Download the Miniconda installer script
    print_step "Downloading the Miniconda installer script"
    curl -O https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh &>> $LOG_DIR/miniconda-install.log

    # Run the installer script
    print_step "Running the Miniconda installer script"
    bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/miniconda &>> $LOG_DIR/miniconda-install.log

    # Initialize Miniconda to automatically update the PATH
    print_step "Initializing Miniconda to automatically update the PATH"
    $HOME/miniconda/bin/conda init &>> $LOG_DIR/miniconda-install.log

    # Activate the base environment
    print_step "Activating the base environment"
    source $HOME/.bashrc
fi