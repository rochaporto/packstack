class { '::nova::cells':
  cell_name                     => hiera('CONFIG_NOVA_CELLS_PARENT_HOST', ''),
  cell_type                     => 'parent',
  cell_parent_name              => undef,
  create_cells                  => false,
  enabled                       => true,
}

File['/etc/nova/nova.conf'] -> Nova_cells<||>
Exec<| title == 'nova-db-sync' |> -> Nova_cells<||>

create_resources('nova_cells', hiera('CONFIG_NOVA_CELLS_CHILDS'))
