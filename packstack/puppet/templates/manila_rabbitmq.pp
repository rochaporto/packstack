
$db_pw = hiera('CONFIG_MANILA_DB_PW')
$mariadb_host = hiera('CONFIG_MARIADB_HOST_URL')

class { '::manila':
  rabbit_host     => hiera('CONFIG_AMQP_HOST_URL'),
  rabbit_port     => hiera('CONFIG_AMQP_CLIENTS_PORT'),
  rabbit_use_ssl  => hiera('CONFIG_AMQP_ENABLE_SSL'),
  rabbit_userid   => hiera('CONFIG_AMQP_AUTH_USER'),
  rabbit_password => hiera('CONFIG_AMQP_AUTH_PASSWORD'),
  sql_connection  => "mysql://manila:${db_pw}@${mariadb_host}/manila",
  verbose         => true,
  debug           => hiera('CONFIG_DEBUG_MODE'),
}
