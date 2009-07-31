package DB::Main::PostCategories;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('post_categories');
__PACKAGE__->add_columns(qw/post_id category_name/);
__PACKAGE__->set_primary_key('post_id', 'category_name');
__PACKAGE__->belongs_to(post_id => 'DB::Main::Post');
__PACKAGE__->belongs_to(category_name => 'DB::Main::Category');

1;
