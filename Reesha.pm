package Reesha;

use strict;
use warnings;
use base 'CGI::Application';
use CGI::Application::Plugin::Stash;
use CGI::Application::Plugin::Mason;
use CGI::Application::Plugin::Session;
use DateTime;

use lib '/home/yousef/reesha';
use DB::Main;

sub cgiapp_init {
    my $self = shift;
    $self->interp_config(comp_root => '/home/yousef/templates', data_dir => '/tmp/mason');
}

sub setup {
    my $self = shift;
    $self->start_mode('main');
    $self->run_modes(
		     'main' => 'reesha',
		     'login' => 'login',
		     'login_process' => 'login_process',
		     'logout' => 'logout',
		     'view' => 'view',
		     );
}

sub reesha {
    my $self = shift;
    # connect to database
    my $schema = DB::Main->connect("dbi:SQLite:dbname=/home/yousef/reesha/reesha.db", "", "") or die;
    my @posts = $schema->resultset('Post')->search({}, { order_by => 'tstamp DESC'});
    $self->stash->{posts} = \@posts;
    $self->stash->{template} = '/reesha.mason';
    return $self->interp_exec;
}

sub view {
    my $self = shift;
    my $schema = DB::Main->connect("dbi:SQLite:dbname=/home/yousef/reesha/reesha.db", "", "") or die;
    # FIX ME, always looks for ID=1
    my @posts = $schema->resultset('Post')->search({ id => 1 });
    $self->stash->{post} = $posts[0];
    $self->stash->{template} = '/view.mason';
    return $self->interp_exec;
}

sub login {
    my $self = shift;
    $self->stash->{template} = '/login.mason';
    return $self->interp_exec;
}

sub logout {
    my $self = shift;
    $self->session->delete;
    $self->stash->{template} = '/logged_out.mason';
    return $self->interp_exec;
}

sub login_process {
    my $self = shift;
    require Data::FormValidator;
    require HTML::FillInForm;
    my $input_profile = {
	required => [qw(username password)],
	constraints => {
	    username => '/^[a-zA-Z_][a-zA-Z0-9_]{2,15}$/',
	    password => '/^[a-zA-Z_][a-zA-Z0-9_]{2,31}$/',
	},
	msgs => {
	    any_errors => 'some_errors',
	    prefix => 'err_',
	},
    };
    my $results = Data::FormValidator->check($self->query, $input_profile);
    $self->stash->{results} = $results;
    if ($results->has_invalid or $results->has_missing) {
	$self->stash->{template} = '/login.mason';
    }
    else {
	# user filled in the form properly. now authenticate them
	my $schema = DB::Main->connect("dbi:SQLite:dbname=/home/yousef/reesha/reesha.db", "", "") or die;
	my $u = $schema->resultset('User')->search({ username => $results->valid('username') });
	my $user = $u->next if $u->count;
	if (defined($user) and $user->password eq $results->valid('password')) {
	    $self->stash->{user} = $user->username;
	    $self->session->delete;
	    $self->session_recreate;
	    $self->session->param('user', $user->username);
	    $self->stash->{template} = '/login_success.mason';
	}
	else {
	    $self->stash->{correct_username} = 1 if defined($user);
	    $self->stash->{template} = '/login.mason';
	}
    }
    return HTML::FillInForm->fill(\$self->interp_exec, $self->query, fill_password => 0);
}

1; # leave this here
