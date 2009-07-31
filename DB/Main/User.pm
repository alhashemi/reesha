package DB::Main::User;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('users');
__PACKAGE__->add_columns(qw/id username realname password created last_login last_ip suspended suspend_notes/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many('posts', 'DB::Main::Post', { 'foreign.user_id' => 'self.id' });
__PACKAGE__->has_many(user_roles => 'DB::Main::UserRoles', 'user_id');
__PACKAGE__->many_to_many(roles => 'user_roles', 'role_name');

1;
