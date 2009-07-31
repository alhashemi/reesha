package DB::Main::UserRoles;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('user_roles');
__PACKAGE__->add_columns(qw/user_id role_name/);
__PACKAGE__->set_primary_key('user_id', 'role_name');
__PACKAGE__->belongs_to(user_id => 'DB::Main::User');
__PACKAGE__->belongs_to(role_name => 'DB::Main::Role');

1;
