package DB::Reesha::Comment;
use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/PK::Auto Core InflateColumn::DateTime/);
__PACKAGE__->table('comments');
__PACKAGE__->add_columns(
    'id'	=> { data_type => 'integer', is_auto_increment => 1 },
    'post_id'	=> { is_foreign_key => 1 },
    'user_id'	=> { is_foreign_key => 1 },
    'comments'	=> { data_type => 'text' },
    'tstamp'	=> { data_type => 'datetime' },
    'approved'	=> { data_type => 'boolean', default_value => 1 },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to('post', 'DB::Reesha::Post', { 'foreign.id' => 'self.post_id' });
__PACKAGE__->belongs_to('user', 'DB::Reesha::User', { 'foreign.id' => 'self.user_id' });

1;
