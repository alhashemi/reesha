package DB::Main::Tag;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('tags');
__PACKAGE__->add_columns(qw/tag/);
__PACKAGE__->set_primary_key('tag');
__PACKAGE__->has_many(post_tags => 'DB::Main::PostTags', 'tag');
__PACKAGE__->many_to_many(posts => 'post_tags', 'post_id');

1;
