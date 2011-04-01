package Reesha;

use strict;
use warnings;

#use lib qw(/home/yousef/reesha /home/yousef/perl5/lib/perl5);
#use lib '/home/yousef/reesha';
#use FindBin qw($Bin);
use base 'CGI::Application';
use CGI::Application::Plugin::Config::Simple; # too many failing Config::YAML reports on cpan-testers
use CGI::Application::Plugin::Stash;
#use CGI::Application::Plugin::Mason;
use CGI::Application::Plugin::TT;
use CGI::Application::Plugin::Session;
use CGI::Application::Plugin::Authentication;

use CGI::Application::Plugin::LogDispatch;


use DateTime;

use DB::Reesha;

our $TEMPLATE_OPTIONS = {
    #INCLUDE_PATH	=> '/home/yousef/templates',
    WRAPPER		=> 'wrapper.tt',
    DEFAULT		=> '404.tt',
};
__PACKAGE__->tt_config(TEMPLATE_OPTIONS => $TEMPLATE_OPTIONS);

__PACKAGE__->authen->config(
    #LOGIN_RUNMODE	=> 'login',
    # or LOGIN_URL
    #LOGOUT_RUNMODE	=> 'logout',
    # or LOGOUT_URL
    DRIVER		=> ['Generic', \&check_credentials],
    STORE		=> 'Session',
    #POST_LOGIN_RUNMODE	=> 'main',
    # or POST_LOGIN_URL
    POST_LOGIN_CALLBACK	=> \&update_last_login_info,
);

sub cgiapp_init {
    my $self = shift;
    #$self->interp_config(comp_root => '/home/yousef/templates', data_dir => '/tmp/mason');
    my $app_dir = $INC[0];
    $self->config_file("$app_dir/reesha.conf");
    $self->tt_include_path([$self->config_param('general.templates_dir')]);
    $self->log_config(
	LOG_DISPATCH_MODULES => [{
	    module		=> 'Log::Dispatch::File',
	    name		=> 'debug',
	    filename	=> '/tmp/debug.log',
	    min_level	=> 'debug',
	}],
    );
    $self->log->info("Logging now\n");
    $self->session_config(
	DEFAULT_EXPIRY		=> '4h', # after 4h idling
    );
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

sub cgiapp_prerun {
    my $self = shift;
    # default content-type/encoding is text/html / utf8
    $self->header_add(-type => 'text/html', -charset => 'utf-8');
}

sub check_credentials {
    #return 'yousefsdfsdfsd';
    my @creds = @_;
    return unless ($#creds == 1); # two parameters provided?
    my $schema = DB::Reesha->connect("dbi:SQLite:dbname=/home/yousef/reesha/reesha.db", "", "") or die;
    my $user = $schema->resultset('User')->search({ username => $creds[0] })->next;
    return (defined($user) && $user->check_password($creds[1])) ? $user->username : undef;
}

sub update_last_login_info {
    my $self = shift;
    return unless($self->authen->is_authenticated);
    my $schema = DB::Reesha->connect("dbi:SQLite:dbname=/home/yousef/reesha/reesha.db", "", "") or die;
    my $user = $schema->resultset('User')->search({ username => $self->authen->username })->next;
    if (defined($user)) { # better be!
	my $time_now = DateTime->now(time_zone => 'UTC');
	$user->last_login_time($time_now);
	$user->last_login_address($self->query->remote_host);
	$user->update;
    }
}

sub reesha {
    my $self = shift;
    #$self->header_add(-type => 'text/plain', -charset => 'utf-8');
    # connect to database
    my $schema = DB::Reesha->connect("dbi:SQLite:dbname=/home/yousef/reesha/reesha.db", "", "") or die;
    my @posts = $schema->resultset('Post')->search({}, { order_by => 'tstamp DESC'});
    $self->stash->{posts} = \@posts;
    #$self->stash->{template} = '/reesha.mason';
    #return $self->interp_exec;
    $self->stash->{title} = 'Reesha - Perl blogging software';
    return $self->tt_process('recent.tt');
}

sub view {
    my $self = shift;
    my $schema = DB::Reesha->connect("dbi:SQLite:dbname=/home/yousef/reesha/reesha.db", "", "") or die;
    # FIX ME, always looks for ID=1
    my @posts = $schema->resultset('Post')->search({ id => 1 });
    $self->stash->{post} = $posts[0];
    $self->stash->{template} = '/view.mason';
    return $self->interp_exec;
}

sub login {
    my $self = shift;
    #$self->stash->{template} = '/login.mason';
    #return $self->interp_exec;
    return $self->tt_process('login.tt');
}

sub logout {
    my $self = shift;
    #$self->session->delete;
    #$self->stash->{template} = '/logged_out.mason';
    #return $self->interp_exec;
    $self->authen->logout;
    return $self->tt_process('login.tt');
}

# no longer used
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
	my $schema = DB::Reesha->connect("dbi:SQLite:dbname=/home/yousef/reesha/reesha.db", "", "") or die;
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
