#! /bin/bash
source $SCRIPT_DIR/utils.sh
CONFIG_FILE=$HOME/.config/vantage6/node/idea4rc.yaml
CONFIG_FILE_TEMPLATE=$SCRIPT_DIR/node.tpl

WRITE_CONFIG_FILE=true
KEEP_PREVIOUS_SETTINGS=false
if [ -f "$CONFIG_FILE" ]; then
    print_warning "Config file already exists at $CONFIG_FILE"

    select_config_option

    if [ "$CONFIG_OPTION" = "1" ]; then
        print_step "Overwriting config file"
    elif [ "$CONFIG_OPTION" = "2" ]; then
        print_step "Updating config file"
        WRITE_CONFIG_FILE=true
        KEEP_PREVIOUS_SETTINGS=true
    elif [ "$CONFIG_OPTION" = "3" ]; then
        print_step "Skipping config file creation"
        WRITE_CONFIG_FILE=false
    fi

fi


if [ "$WRITE_CONFIG_FILE" = true ]; then


    if [ "$KEEP_PREVIOUS_SETTINGS" = true ]; then
        # check that $SCRIPT_DIR/settings.env exists
        if [ ! -f "$SCRIPT_DIR/settings.env" ]; then
            print_error "settings.env file not found at $SCRIPT_DIR/settings.env"
            print_error "You need to enter the settings manually"
            KEEP_PREVIOUS_SETTINGS=false
        else
            print_step "Using previous settings"
            # we want to safe the newly inputted data
            source $SCRIPT_DIR/settings.env
        fi
    fi

    # Create config dir
    print_step "Creating config dir"
    mkdir -p $HOME/.config

    # Create config file
    print_step "Creating config file"

    # Vantage6 node settings
    export TASK_DIR=$HOME/tasks
    mkdir -p $TASK_DIR

    is_set_or_prompt "API_KEY"
    export API_KEY=$API_KEY

    # OMOP database settings
    is_set_or_prompt "OMOP_API_PROTOCOL" "http/https"
    export OMOP_API_PROTOCOL=$OMOP_API_PROTOCOL
    is_set_or_prompt "OMOP_API_URI" "ip or domain"
    export OMOP_API_URI=$OMOP_API_URI
    is_set_or_prompt "OMOP_API_PORT" "typically 80 or 443"
    export OMOP_API_PORT=$OMOP_API_PORT

    select_whitelist_method

    case "$WHITELIST_VERSION" in
        "Domain")
            # Code to execute if DB_METHOD is "docker"

            is_set_or_prompt "WHITELIST_DOMAIN"
            export WHITELIST_DOMAIN=$WHITELIST_DOMAIN
            include_content=$(<$SCRIPT_DIR/templates/whitelist-domain.tpl)

            ;;
        "IP")
            # Code to execute if DB_METHOD is "ssh_tunnel"
            is_set_or_prompt "WHITELIST_IP"
            export WHITELIST_IP=$WHITELIST_IP
            include_content=$(<$SCRIPT_DIR/templates/whitelist-ip.tpl)
            ;;
        *)
            # Code to execute if DB_METHOD is anything else
            print_error "Invalid option $WHITELIST_VERSION. Exiting..."
            exit 1
            ;;
    esac
    is_set_or_prompt "WHITELIST_PORT"
    export WHITELIST_PORT=$WHITELIST_PORT

    escaped_content=$(echo "$include_content" | sed -e ':a' -e 'N' -e '$!ba' -e 's/[\/&]/\\&/g' -e 's/\n/NEWLINE/g')
    sed "s/{{WHITELIST}}/$escaped_content/g" $SCRIPT_DIR/templates/node-config.tpl | sed 's/NEWLINE/\n/g' > $CONFIG_FILE_TEMPLATE
    # sed "s/{{WHITELIST}}/$escaped_content/" $SCRIPT_DIR/templates/node-config.tpl > $CONFIG_FILE_TEMPLATE

    # # Create the config file
    print_step "Creating the config file"
    mkdir -p $HOME/.config/vantage6/node

    print_step "Creating the vantage6 config file"
    create_config_file $CONFIG_FILE_TEMPLATE $CONFIG_FILE

    if [ "$KEEP_PREVIOUS_SETTINGS" = false ]; then
        print_step "Creating environment file"
        echo "export API_KEY=$API_KEY" > $SCRIPT_DIR/settings.env

        echo "export OMOP_API_PROTOCOL=$OMOP_API_PROTOCOL" >> $SCRIPT_DIR/settings.env
        echo "export OMOP_API_URI=$OMOP_API_URI" >> $SCRIPT_DIR/settings.env
        echo "export OMOP_API_PORT=$OMOP_API_PORT" >> $SCRIPT_DIR/settings.env

        if is_set "WHITELIST_DOMAIN" "silent"; then
            echo "export WHITELIST_DOMAIN=$WHITELIST_DOMAIN" >> $SCRIPT_DIR/settings.env
        fi
        if is_set "WHITELIST_IP" "silent"; then
            echo "export WHITELIST_IP=$WHITELIST_IP" >> $SCRIPT_DIR/settings.env
        fi
        echo "export WHITELIST_PORT=$WHITELIST_PORT" >> $SCRIPT_DIR/settings.env
    fi

fi


