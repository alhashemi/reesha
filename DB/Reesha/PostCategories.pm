package DB::Reesha::PostCategories;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('post_categories');
__PACKAGE__->add_columns(
    'post_id'		=> { is_foreign_key => 1 },
    'category_name'	=> { is_foreign_key => 1 },
);
__PACKAGE__->set_primary_key('post_id', 'category_name');
__PACKAGE__->belongs_to(post_id => 'DB::Reesha::Post');
__PACKAGE__->belongs_to(category_name => 'DB::Reesha::Category');

1;
