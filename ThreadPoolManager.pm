package ThreadPoolManager;

use strict;
use warnings;

use Config;
use threads;

my $pool;

sub new 
{
   log_msg("ThreadPoolManager::NEW");

   my $class = shift;
   
   my $self = {
      poolSize => 0,
      manager => sub {},
      @_
   };

   bless $self, $class;
   
   $self->_Init();
   return $self;
}

sub _Init
{
   log_msg("ThreadPoolManager::INIT");

   my $self = shift;
   print "Settings ...\n";
   foreach (keys(%$self)) {
      print "$_ -> $self->{$_}\n";
   }

   print "Starting Thread Manager ....\n";
   $self->{manager}();
}

sub AddThread
{
   log_msg("ThreadPoolManager::AddThread");

   my $self = shift;
   my $threadMethod = shift or return;
   my @threadArguments = (\&OnComplete, @_);

   my $worker = threads->create($threadMethod, @threadArguments);
   $pool->{$worker->tid} = 1;
   $worker->detach();
}

sub OnComplete
{
   my $tid = shift;
   my $data = @_;

   print $tid;

   $pool->{$tid} = 0;
   delete $pool->{$tid};
}

sub ThreadCount
{
   #log_msg("ThreadPoolManager::ThreadCount");

   my $count = 0;
   $count++ foreach (keys(%$pool));
   return $count;
}

sub PoolSize
{
   #log_msg("ThreadPoolManager::PoolSize");

   my $self = shift;
   return $self->{poolSize};
}

sub DESTROY
{
   log_msg("ThreadPoolManager::DESTROY");
   my $self = shift;
}

sub log_msg
{
   my $msg = shift or return;
   print "[LOG] $msg\n";
}

1;