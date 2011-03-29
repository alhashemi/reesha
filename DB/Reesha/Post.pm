package DB::Reesha::Post;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('posts');
__PACKAGE__->add_columns(
    'id'		=> { data_type => 'integer', is_auto_increment => 1 },
    'user_id'		=> { is_foreign_key => 1 },
    'title'		=> { data_type => 'varchar', size => 255 },
    'body_header'	=> { data_type => 'text' },
    'full_body'		=> { data_type => 'text' },
    'tstamp'		=> { data_type => 'datetime' },
    'enable_comments'	=> { data_type => 'boolean', default_value => 1 },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('user', 'DB::Reesha::User', { 'foreign.id' => 'self.user_id' });
__PACKAGE__->has_many('comments', 'DB::Reesha::Comment', { 'foreign.post_id' => 'self.id' });
__PACKAGE__->has_many(post_categories => 'DB::Reesha::PostCategories', 'post_id');
__PACKAGE__->many_to_many(categories => 'post_categories', 'category_name');

1;
