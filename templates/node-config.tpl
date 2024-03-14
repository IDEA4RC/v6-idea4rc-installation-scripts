# API key used to authenticate at the server.
api_key: ${API_KEY}

# URL of the vantage6 server
server_url: https://blueberry.vantage6.ai

# port the server listens to
port: 443

# API path prefix that the server uses. Usually '/api' or an empty string
api_path: ''

# # subnet of the VPN server
# vpn_subnet: 10.76.0.0/16

# set the devices the algorithm container is allowed to request.
algorithm_device_requests:
  gpu: false

# # Add additional environment variables to the algorithm containers. In case
# # you want to supply database specific environment (e.g. usernames and
# # passwords) you should use `env` key in the `database` section of this
# # configuration file.
# # OPTIONAL
# algorithm_env:

#   # in this example the environment variable 'player' has
#   # the value 'Alice' inside the algorithm container
#   player: Alice

# # specify custom Docker images to use for starting the different
# # components.
# # OPTIONAL
# images:
#   node: harbor2.vantage6.ai/infrastructure/node:cotopaxi
#   alpine: harbor2.vantage6.ai/infrastructure/alpine
#   vpn_client: harbor2.vantage6.ai/infrastructure/vpn_client
#   network_config: harbor2.vantage6.ai/infrastructure/vpn_network
#   ssh_tunnel: harbor2.vantage6.ai/infrastructure/ssh_tunnel
#   squid: harbor2.vantage6.ai/infrastructure/squid

# path or endpoint to the local data source. The client can request a
# certain database by using its label. The type is used by the
# auto_wrapper method used by algorithms. This way the algorithm wrapper
# knows how to read the data from the source. The auto_wrapper currently
# supports: 'csv', 'parquet', 'sql', 'sparql', 'excel', 'omop'. If your
# algorithm does not use the wrapper and you have a different type of
# data source you can specify 'other'.
databases:
  # - label: default
  #   uri: C:\data\datafile.csv
  #   type: csv

  - label: omop_api
    uri: ${OMOP_API_PROTOCOL}://${OMOP_API_URI}:${OMOP_API_PORT}
    type: other
    # additional environment variables that are passed to the algorithm
    # containers (or their wrapper). This can be used to for usernames
    # and passwords for example. Note that these environment variables are
    # only passed to the algorithm container when the user requests that
    # database. In case you want to pass some environment variable to all
    # algorithms regard less of the data source the user specifies you can
    # use the `algorithm_env` setting.
    # env:
    #   user: ${OMOP_USER}
    #   password: ${OMOP_PASSWORD}
    #   dbms: postgresql
    #   cdm_database: ${OMOP_DATABASE}
    #   cdm_schema: ${OMOP_CDM_SCHEMA}
    #   results_schema: ${OMOP_RESULT_SCHEMA}



# end-to-end encryption settings
encryption:

  # whenever encryption is enabled or not. This should be the same
  # as the `encrypted` setting of the collaboration to which this
  # node belongs.
  enabled: false

#   # location to the private key file
#   private_key: /path/to/private_key.pem

# Define who is allowed to run which algorithms on this node.
policies:
  # Control which algorithm images are allowed to run on this node. This is
  # expected to be a valid regular expression.
  allowed_algorithms:
    - ^harbor2\.vantage6\.ai/[a-zA-Z]+/[a-zA-Z]+
    # - myalgorithm.ai/some-algorithm
  # # Define which users are allowed to run algorithms on your node by their ID
  # allowed_users:
  #   - 2
  # # Define which organizations are allowed to run images on your node by
  # # their ID or name
  # allowed_organizations:
  #   - 6
  #   - root

  # The basics algorithm (harbor2.vantage5.ai/algorithms/basics) is whitelisted
  # by default. It is used to collect column names in the User Interface to
  # facilitate task creation. Set to false to disable this.
  allow_basics_algorithm: true

# # credentials used to login to private Docker registries
# docker_registries:
#   - registry: docker-registry.org
#     username: docker-registry-user
#     password: docker-registry-password

{{WHITELIST}}

# # Whitelist URLs and/or IP addresses that the algorithm containers are
# # allowed to reach using the http protocol.
# whitelist:
#   domains:
#     - google.com
#     - github.com
#     - host.docker.internal # docker host ip (windows/mac)
#   ips:
#     - 172.17.0.1 # docker bridge ip (linux)
#     - 8.8.8.8
#   ports:
#     - 443


# Settings for the logger
logging:
  # Controls the logging output level. Could be one of the following
  # levels: CRITICAL, ERROR, WARNING, INFO, DEBUG, NOTSET
  level:        DEBUG

  # whenever the output needs to be shown in the console
  use_console:  true

  # The number of log files that are kept, used by RotatingFileHandler
  backup_count: 5

  # Size kb of a single log file, used by RotatingFileHandler
  max_size:     1024

  # Format: input for logging.Formatter,
  format:       "%(asctime)s - %(name)-14s - %(levelname)-8s - %(message)s"
  datefmt:      "%Y-%m-%d %H:%M:%S"

  # (optional) set the individual log levels per logger name, for example
  # mute some loggers that are too verbose.
  loggers:
    - name: urllib
      level: warning
    - name: requests
      level: warning
    - name: engineio.client
      level: warning
    - name: docker.utils.config
      level: warning
    - name: docker.auth
      level: warning

# Additional debug flags
debug:

  # Set to `true` to enable the Flask/socketio into debug mode.
  socketio: false

  # Set to `true` to set the Flask app used for the LOCAL proxy service
  # into debug mode
  proxy_server: false

# directory where local task files (input/output) are stored
task_dir: ${TASK_DIR}

# Whether or not your node shares some configuration (e.g. which images are
# allowed to run on your node) with the central server. This can be useful
# for other organizations in your collaboration to understand why a task
# is not completed. Obviously, no sensitive data is shared. Default true
share_config: true