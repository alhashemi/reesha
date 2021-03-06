package DB::Reesha::Category;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('categories');
__PACKAGE__->add_columns('name' => { data_type => 'varchar', size => 64 });
__PACKAGE__->set_primary_key('name');
__PACKAGE__->has_many(post_categories => 'DB::Reesha::PostCategories', 'category_name');
__PACKAGE__->many_to_many(posts => 'post_categories', 'post_id');

1;
