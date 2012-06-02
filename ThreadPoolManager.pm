package ThreadPoolManager;

use strict;
use warnings;

use Config;
use threads;
use threads::shared;

my %threadPool : shared;

sub new 
{
   log_msg("ThreadPoolManager::NEW");

   my $class = shift;
   
   my $self = {
      poolSize       => 0,
      threadCount    => 0,
      manager        => sub {},
      @_
   };

   bless $self, $class;
   $self->_init();

   return $self;
}

sub DESTROY { my $self = shift; $self->destroy(); }
sub destroy
{
   log_msg("ThreadPoolManager::DESTROY");
   my $self = shift;
}

sub _init
{
   my $self = shift;

   $self->{manager}->($self);
}

sub threadCount
{
   my $self = shift;

   my $count = 0;
   {
      lock(%threadPool);
      foreach (keys(%threadPool))
      {
         $count++ if $threadPool{$_} == 1;
      }
   }

   return $count;
}

sub poolSize
{
   my $self = shift;
   return $self->{poolSize};
}

sub registerThread
{
   my $self = shift;
   my $threadMethod = shift or return;
   my @threadArgs = ( sub { my $tid = shift; $self->unregisterThread($tid); }, @_);

   my $thread = threads->create($threadMethod, @threadArgs);
   $threadPool{$thread->tid} = 1;
   $thread->detach();
}

sub unregisterThread
{
   log_msg("ThreadPoolManager::unregisterThread");

   my $self = shift;
   my $tid = shift;

   lock(%threadPool);
   $threadPool{$tid} = 0 if (exists($threadPool{$tid}));
}

sub log_msg
{
   my $msg = shift or return;
   print "[LOG] $msg\n";
}

1;