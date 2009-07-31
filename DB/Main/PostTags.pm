package DB::Main::PostTags;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('post_tags');
__PACKAGE__->add_columns(qw/post_id tag/);
__PACKAGE__->set_primary_key('post_id', 'tag');
__PACKAGE__->belongs_to(post_id => 'DB::Main::Post');
__PACKAGE__->belongs_to(tag => 'DB::Main::Tag');

1;
