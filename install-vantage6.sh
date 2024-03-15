#!/bin/bash

# just to make sure all is loaded
source $HOME/.bashrc

# Print the current time and user
source $SCRIPT_DIR/utils.sh
print_info &>> $LOG_DIR/vantage6-install.log

if ! (command -v conda &> /dev/null); then
    print_error "Conda not available? Open a new shell and try again."
fi

# Check if the vantage6 environment already exists
print_step "Checking if the vantage6 environment already exists"
if conda env list | grep -q 'vantage6'
then
    print_warning "The vantage6 environment already exists" | tee -a $LOG_DIR/vantage6-install.log
else
    # Create a new conda environment with Python 3.10
    print_step "Creating a new conda environment with Python 3.10"
    conda create -n vantage6 python=3.10 -y &>> $LOG_DIR/vantage6-install.log
fi

# Activate the new environment
print_step "Activating the (new) environment"
conda activate vantage6 &>> $LOG_DIR/vantage6-install.log

# Install the vantage6 package
print_step "Checking if the vantage6 package is already installed"
if pip freeze | grep -q 'vantage6=='
then
    # Print the version of the vantage6 package
    print_warning "The vantage6 package is already installed" | tee -a $LOG_DIR/vantage6-install.log
    vantage6_version=$(pip show vantage6 | grep Version | cut -d ' ' -f 2)
    print_step "vantage6 version: $vantage6_version" | tee -a $LOG_DIR/vantage6-install.log

    # Ask for confirmation to upgrade the vantage6 package
    if confirm "Do you want to try to upgrade the vantage6 package?"
    then
        print_step "Upgrading the vantage6 package"
        pip install --upgrade vantage6 &>> $LOG_DIR/vantage6-install.log
    fi
else
    # Install the vantage6 package
    print_step "Installing the vantage6 package"
    pip install vantage6 &>> $LOG_DIR/vantage6-install.log
fi

vantage6_version=$(pip show vantage6 | grep Version | cut -d ' ' -f 2)
print_step "vantage6 version: $vantage6_version" | tee -a $LOG_DIR/vantage6-install.log