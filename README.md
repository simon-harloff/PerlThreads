PerlThreads
===========

This is me playing around with Perl threading.

**Update: ThreadPoolManager is now thread completion aware**

This means that clients code can implement a listeners that allows for the processing
of these notifications along with the data that was submitted by the thread. This is useful
if the completion of the program is dependant on the execution progress of threads. 

**Update: ThreadPoolManager module working**

I have made some changes to the ThreadPoolManager package. It now manages
threads properly. 

Need to implement threads being able to return some data to the thread pool
manager so the managing method can be notified of the progress.

**In order to run the example:**

`perl threads.pl`

This assumes that you have Perl threads installed as part of your Perl compilation.

## Basic Documentation

For now look at **threads.pl** for some idea on how to use `ThreadPoolManager.pm`

TODO

** Client code requirements **

** ThreadPoolManager package notes **