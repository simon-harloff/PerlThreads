use strict;
use warnings;

# include custom ThreadPoolManager package
use ThreadPoolManager;

# turn off output buffering
local $| = 0;

# simple example to use threads to count
# to 50 and stop when we have reached the target
my $countTarget   = 50;
my $count : shared = 0;
# NOTE: $count is a shared variable, it is important
# that variables used to keep track of the thread
# execution are set to shared

Main();

sub Main
{

   # create a new thread pool manager
   # configure with the following:
   #     poolSize - desired thread pool size
   #     manager - the method that will manage the thread creation
   #     onThreadDone - the method invoked when a thread is done
   my $tpm = new ThreadPoolManager(
      poolSize       => 3,
      manager        => \&ManageThreads,
      onThreadDone   => \&ProcessThreadNotification
   );

}

sub ManageThreads
{
   # manager methods need a reference to the tpm instance
   # calling it so we can get thread count and pool size
   # for the currently configured instance
   my $tpm = shift;

   while (1) {
      # check whether our current thread count is below
      # configured thread pool size
      while ($tpm->getThreadCount() < $tpm->getPoolSize()) {
         $tpm->registerThread(\&Worker);
      }

      sleep 1;
      print "Count is up to: " . $count . "\n";

      # exit out of the loop if we have reached out our
      # execution target
      last if ($count >= $countTarget);
   }
}

sub ProcessThreadNotification
{
   # onThreadDone methods need a reference to the tpm instance
   # calling it so we cant acquire new thread data
   my $tpm = shift;

   # get the accumulated thread data
   my @data = $tpm->getThreadData();

   # done some custom processing with the data
   # TODO: possibly need to take a lock on
   # any variables that are going to be modified by this 
   # thread notification method, however basic tests indicate
   # this method works for now
   while (@data) {
      my $el = shift @data;
      $count += $el;

      print "\tData received: $el\n";
   }

   print "Count is up to: " . $count . "\n";
}

# basic worker method
# sleeps for up to 10 seconds and then
# returns the number of seconds slept
sub Worker
{
   my $cb = shift;
   my $num = sprintf("%d", rand(10));
   sleep $num;
   
   $cb->(threads->self->tid, $num);
}

# helper method (ignore this one)
sub log_msg
{
   my $msg = shift or return;
   print "[LOG] $msg\n";
}