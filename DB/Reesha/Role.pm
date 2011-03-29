package DB::Reesha::Role;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('roles');
__PACKAGE__->add_columns(qw/name description/);
__PACKAGE__->add_columns(
    'name'		=> { data_type => 'varchar', size => 64 },
    'description'	=> { data_type => 'text' },
);
__PACKAGE__->set_primary_key('name');
__PACKAGE__->has_many(user_roles => 'DB::Reesha::UserRoles', 'role_name');
__PACKAGE__->many_to_many(users => 'user_roles', 'user_id');

1;
