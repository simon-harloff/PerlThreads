use strict;
use warnings;

use ThreadPoolManager;

local $| = 0;

Main();

sub Main
{

   my $tpm = new ThreadPoolManager(
      poolSize => 5,
      manager  => \&ManageThreads
   );

}

sub ManageThreads
{
   log_msg("ManageThreads ...");
   my $tpm = shift;

   while (1) {
      log_msg("Current Active Threads: " . $tpm->threadCount());
      while ($tpm->threadCount() < $tpm->poolSize()) {
         $tpm->registerThread(\&Worker);
      }
      sleep 1;
   }
}

sub Worker
{
   my $cb = shift;
   log_msg("\t\t Working ...");
   sleep 3;
   log_msg("\t\t Done ...");
   
   $cb->(threads->self->tid);
}

sub log_msg
{
   my $msg = shift or return;
   print "[LOG] $msg\n";
}