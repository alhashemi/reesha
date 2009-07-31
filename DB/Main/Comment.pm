package DB::Main::Comment;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core/);
__PACKAGE__->table('comments');
__PACKAGE__->add_columns(qw/id post_id name comments tstamp approved/);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('post', 'DB::Main::Post', { 'foreign.id' => 'self.post_id' });

1;
