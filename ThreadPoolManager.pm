package ThreadPoolManager;

use strict;
use warnings;

use Config;
use threads;
use threads::shared;

my %threadPool : shared;
my @threadData : shared;

sub new 
{
   my $class = shift;
   
   my $self = {
      poolSize       => 0,
      threadCount    => 0,
      manager        => sub {},
      onThreadDone   => sub {},
      @_
   };

   bless $self, $class;
   $self->_init();

   return $self;
}

sub DESTROY { my $self = shift; $self->destroy(); }
sub destroy
{
   my $self = shift;
}

sub _init
{
   my $self = shift;

   $self->{manager}->($self);
}

sub getThreadCount
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

sub getPoolSize
{
   my $self = shift;
   return $self->{poolSize};
}

sub getThreadData
{
   my @data = ();
   {
      lock(@threadData);
      @data = @threadData;
      @threadData = ();
   }
   return @data;
}

sub registerThread
{
   my $self = shift;
   my $threadMethod = shift or return;
   my @threadArgs = ( sub { my $tid = shift; my @data = (@_); $self->unregisterThread($tid, @data); }, @_);

   my $thread = threads->create($threadMethod, @threadArgs);
   $threadPool{$thread->tid} = 1;
   $thread->detach();
}

sub unregisterThread
{
   my $self = shift;
   my $tid = shift or return;
   my @data = (@_);

   {
      lock(%threadPool);
      $threadPool{$tid} = 0 if (exists($threadPool{$tid}));
   }

   {
      lock(@threadData);
      push(@threadData, @data);
   }

   $self->{onThreadDone}->($self);
}

1;