PerlThreads
===========

This is me playing around with Perl threading.

**Update: ThreadPoolManager module working**

I have made some changes to the ThreadPoolManager package. It now manages
threads properly. 

Need to implement threads being able to return some data to the thread pool
manager so the managing method can be notified of the progress.

**In order to run the example:**

`perl threads.pl`

This assumes that you have Perl threads installed as part of your Perl compilation.