# API key used to authenticate at the server.
api_key: ${API_KEY}

# URL of the vantage6 server
server_url: https://blueberry.vantage6.ai

# port the server listens to
port: 443

# API path prefix that the server uses. Usually '/api' or an empty string
api_path: ''

# set the devices the algorithm container is allowed to request.
algorithm_device_requests:
  gpu: false

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
# supports: 'csv', 'parquet', 'sql', 'sparql', 'excel', 'other'. If your
# algorithm does not use the wrapper and you have a different type of
# data source you can specify 'other'.
databases:
  # - label: default
  #   uri: C:\data\datafile.csv
  #   type: csv

  - label: omop_api
    uri: ${OMOP_API_PROTOCOL}://${OMOP_API_URI}:${OMOP_API_PORT}${OMOP_API_PATH}
    type: other

# end-to-end encryption settings
encryption:

  # whenever encryption is enabled or not. This should be the same
  # as the `encrypted` setting of the collaboration to which this
  # node belongs.
  enabled: false

# Define who is allowed to run which algorithms on this node.
policies:
  # Control which algorithm images are allowed to run on this node. This is
  # expected to be a valid regular expression.
  allowed_algorithms:
    - ^harbor2\.vantage6\.ai/[a-zA-Z]+/[a-zA-Z]+
    # - myalgorithm.ai/some-algorithm

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
    - name: urllib3
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
