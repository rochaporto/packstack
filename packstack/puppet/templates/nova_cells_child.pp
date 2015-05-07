class { '::nova::cells':
  cell_name                     => $::ipaddress,
  cell_type                     => 'child',
  cell_parent_name              => hiera('CONFIG_NOVA_CELLS_PARENT_HOST', ''),
  create_cells                  => true,
  enabled                       => true,
}

File['/etc/nova/nova.conf'] -> Nova_cells<||>
Exec<| title == 'nova-db-sync' |> -> Class['nova::cells'] -> Nova_cells<||>

$parent_name = hiera('CONFIG_NOVA_CELLS_PARENT_HOST', '')
nova_cells { $parent_name:
  ensure              => present,
  cell_type           => 'parent',
  rabbit_username     => 'guest',
  rabbit_password     => 'guest',
  rabbit_hosts        => hiera('CONFIG_AMQP_HOST', 'localhost'),
  rabbit_port         => hiera('CONFIG_AMQP_CLIENTS_PORT', '5672'),
  rabbit_virtual_host => '/',
  weight_offset       => '1.0',
  weight_scale        => '1.0',
}
