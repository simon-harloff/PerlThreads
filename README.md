PerlThreads
===========

_NTB: Check spelling for submitting readme :S_

This is me playing around with Perl threading.

**Update: ThreadPoolManager is now thread completion aware**

This means that client code can implement a listener that allows for the processing
of these thread completion notifications.

Thread completion notifications also pass return data submitted by the thread back to client code.

This is useful if the completion of the program is dependant on the execution progress of threads. 

**Update: ThreadPoolManager module working**

I have made some changes to the ThreadPoolManager package. It now manages threads properly. 

Need to implement threads being able to return some data to the thread pool
manager so the managing method can be notified of the progress.

**In order to run the example:**

`perl threads.pl`

This assumes that you have Perl threads installed as part of your Perl compilation. You can check if you 
have threads available with the following code:

`use Config;`
`$Config{useithreads} or die('Recompile Perl with threads to run this program.');`

If you get the die("...") part of th perl program that congratulations you do **NOT** have threads. :P

## Basic Documentation

For now look at **threads.pl** for some idea on how to use `ThreadPoolManager.pm`

TODO

** Client code requirements **

** ThreadPoolManager package notes **