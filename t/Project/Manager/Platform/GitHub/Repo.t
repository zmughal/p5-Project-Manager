use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;

use Project::Manager::Platform::GitHub::Repo;

my %common_data = ( namespace => 'test', name => 'repo' );
my $data = [
	## Git URI
	{ uri => 'git://github.com/test/repo.git', %common_data },
	{ uri => 'git://github.com/test/repo', %common_data },

	## SCP syntax
	{ uri => 'git@github.com:test/repo.git' , %common_data },
	{ uri => 'git@github.com:test/repo' , %common_data },

	## HTTPS
	{ uri => 'https://github.com/test/repo.git' , %common_data },
	{ uri => 'https://github.com/test/repo' , %common_data },

	## HTTP
	{ uri => 'http://github.com/test/repo.git', %common_data  },
	{ uri => 'http://github.com/test/repo', %common_data  },
];

subtest "Throws exceptions for bad URIs" => sub {
	for my $repo (@$data) {
		lives_ok { Project::Manager::Platform::GitHub::Repo->new( uri => $repo->{uri} ) } 'valid GitHub URI';
	}
};

subtest "Correct name extraction" => sub {
	for my $repo (@$data) {
		my $gh = Project::Manager::Platform::GitHub::Repo->new( uri => $repo->{uri} );
		is( $gh->namespace, $repo->{namespace}, "correct namespace from $repo->{uri}" );
		is( $gh->name, $repo->{name}, "correct name from $repo->{uri}" );
	}
};

subtest 'HTTPS web URI' => sub {
	my $gr = Project::Manager::Platform::GitHub::Repo->new( uri => 'git@github.com:test/repo.git' );
	is( $gr->github_https_web_uri, 'https://github.com/test/repo', 'correct HTTPS web URI for GitHub repo');
};

subtest 'Pithub data' => sub {
	my $gr = Project::Manager::Platform::GitHub::Repo->new( namespace => 'SeeLucid', name => 'p5-Project-Manager' );
	my $repo_data =  $gr->pithub_data->first;
	ok( $repo_data );
};

subtest 'Get issues' => sub {
	my $gr = Project::Manager::Platform::GitHub::Repo->new( namespace => 'SeeLucid', name => 'p5-Project-Manager' );
	my $repo_data =  $gr->issues;
	use DDP; p $repo_data;
	ok( $repo_data );
};
