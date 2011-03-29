package DB::Reesha::UserRoles;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('user_roles');
__PACKAGE__->add_columns(qw/user_id role_name/);
__PACKAGE__->add_columns(
    'user_id'	=> { is_foreign_key => 1 },
    'role_name'	=> { is_foreign_key => 1 },
);
__PACKAGE__->set_primary_key('user_id', 'role_name');
__PACKAGE__->belongs_to(user_id => 'DB::Reesha::User');
__PACKAGE__->belongs_to(role_name => 'DB::Reesha::Role');

1;
