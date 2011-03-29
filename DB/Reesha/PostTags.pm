package DB::Reesha::PostTags;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('post_tags');
__PACKAGE__->add_columns(
    'post_id'	=> { is_foreign_key => 1 },
    'tag'	=> { is_foreign_key => 1 },
);
__PACKAGE__->set_primary_key('post_id', 'tag');
__PACKAGE__->belongs_to(post_id => 'DB::Reesha::Post');
__PACKAGE__->belongs_to(tag => 'DB::Reesha::Tag');

1;
