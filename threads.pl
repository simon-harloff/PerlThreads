use strict;
use warnings;

use Config;
use threads;
use threads::shared;

my %threadPool : shared;
my $threadPoolSize = 1;
my $threadCount = 0;


$| = 0;

Main();

sub Main
{
   log_msg("Starting ...");
   while (1) {
      $threadCount = 0;
      print "Active Threads: ";
      foreach (keys(%threadPool)) {
         print " $_ -> $threadPool{$_}, ";
         $threadCount++ if ($threadPool{$_});
      }
      print "\n";

      while ($threadCount < $threadPoolSize) {
         log_msg("Spawning worker thread ...");
         my $thread = threads->create(\&Worker);
         $threadPool{$thread->tid} = 1;
         $thread->detach();
         $threadCount++;
      }
      sleep 5;
   }
}

sub Worker
{
   log_msg("\t\t Working ...");
   sleep 3;
   log_msg("\t\t Done ...");
   $threadPool{threads->self->tid} = 0;
}

sub log_msg
{
   my $msg = shift or return;
   print "[LOG] $msg\n";
}