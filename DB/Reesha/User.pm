package DB::Reesha::User;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto EncodedColumn Core InflateColumn::DateTime/);
__PACKAGE__->table('users');
__PACKAGE__->add_columns(
    'id'			=> { data_type => 'integer', is_auto_increment => 1 },
    'username'			=> { data_type => 'varchar', size => 16 },
    'name'			=> { data_type => 'varchar', size => 64 },
    'password'			=> {
					data_type		=> 'char',
					size			=> 60,
					encode_column		=> 1,
					encode_class		=> 'Crypt::Eksblowfish::Bcrypt',
					encode_args		=> { key_nul => 0, cost => 8 },
					encode_check_method	=> 'check_password',
				   },
    'email_address'		=> { data_type => 'varchar', size => 255 },
    'confirmed'			=> { data_type => 'boolean', default_value => 0 },
    'created'			=> { data_type => 'datetime' },
    'last_login_time'		=> { data_type => 'datetime', is_nullable => 1 },
    'last_login_address'       	=> { data_type => 'varchar', size => 255, is_nullable => 1 },
    'suspended'			=> { data_type => 'boolean', default_value => 0 },
    'suspend_notes'		=> { data_type => 'text', is_nullable => 1 },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(username_constraint => ['username']);
__PACKAGE__->has_many('posts', 'DB::Reesha::Post', { 'foreign.user_id' => 'self.id' });
#__PACKAGE__->has_many(user_roles => 'DB::Reesha::UserRoles', 'user_id');
__PACKAGE__->has_many('user_roles', 'DB::Reesha::UserRoles', 'user_id');
__PACKAGE__->many_to_many(roles => 'user_roles', 'role_name');

1;
