$config_use_neutron = hiera('CONFIG_NEUTRON_INSTALL')

if $config_use_neutron == 'y' {
    $default_floating_pool = 'public'
} else {
    $default_floating_pool = 'nova'
}

# Ensure Firewall changes happen before nova services start
# preventing a clash with rules being set by nova-compute and nova-network
Firewall <| |> -> Class['nova']

$user = hiera('CONFIG_NOVA_DB_USER', 'nova')
$password = hiera('CONFIG_NOVA_DB_PW', '')
$config_use_cells = hiera('CONFIG_NOVA_CELLS_ENABLE')
if $config_use_cells {
    $host = 'localhost'
} else {
    $host = hiera('CONFIG_NOVA_DB_HOST')
}
$sqlconn = "mysql://${user}@${host}/nova"
nova_config{
  'DEFAULT/sql_connection':        value => $sqlconn;
  'DEFAULT/metadata_host':         value => hiera('CONFIG_CONTROLLER_HOST');
  'DEFAULT/default_floating_pool': value => $default_floating_pool;
}
