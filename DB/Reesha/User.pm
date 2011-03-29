package DB::Reesha::User;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('users');
__PACKAGE__->add_columns(
    'id'			=> { data_type => 'integer', is_auto_increment => 1 },
    'username'			=> { data_type => 'varchar', size => 16 },
    'name'			=> { data_type => 'varchar', size => 64 },
    'password'			=> { data_type => 'text' },
    'email_address'		=> { data_type => 'varchar', size => 255 },
    'confirmed'			=> { data_type => 'boolean', default_value => 0 },
    'created'			=> { data_type => 'datetime' },
    'last_login_time'		=> { data_type => 'datetime' },
    'last_login_address'       	=> { data_type => 'varchar', size => 255 },
    'suspended'			=> { data_type => 'boolean', default_value => 0 },
    'suspend_notes'		=> { data_type => 'text', is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many('posts', 'DB::Reesha::Post', { 'foreign.user_id' => 'self.id' });
__PACKAGE__->has_many(user_roles => 'DB::Reesha::UserRoles', 'user_id');
__PACKAGE__->many_to_many(roles => 'user_roles', 'role_name');

1;
