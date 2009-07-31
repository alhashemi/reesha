package DB::Main::Post;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('posts');
__PACKAGE__->add_columns(qw/id user_id title body_header full_body tstamp comments/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('user', 'DB::Main::User', { 'foreign.id' => 'self.user_id' });
__PACKAGE__->has_many('comments', 'DB::Main::Comment', { 'foreign.post_id' => 'self.id' });
__PACKAGE__->has_many(post_categories => 'DB::Main::PostCategories', 'post_id');
__PACKAGE__->many_to_many(categories => 'post_categories', 'category_name');

1;
