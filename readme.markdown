# The Problem

I encountered an odd problem where the block in a `dispatch_async(dispatch_get_main_queue(), ^{})` does not execute. 

In the app I'm working on, a `dispatch_async(dispatch_get_main_queue(), ^{})` is used to display a modal window. Based on user actions, the modal window will makes some network calls on a background thread. When the background thread completed it dispatches the results to the main thread using `dispatch_async(dispatch_get_main_queue(), ^{})`. However, the block never executed. 

To work around this problem, I had to use `-[NSObject performSelectorOnMainThread:withObject:waitUntilDone:]` instead. 

Here is a [blog post][1] I wrote on my theory on why this problem is happening.

Update: It was pointed out to me by [Mike Ash][mikeash] that NSRunLoop is reentrant but GCD serial queues are not. The main queue is a serial queue. In the scenario where I encountered the problem, the main queue is already executing the block and it won't execute the new block until the first one is done. This is why the other block is never executed. As Mike said, "This is a subtle way in which dispatch on the main queue isn't the same as `performSelectorOnMainThread`." Thanks, Mike!

# The Problem In Action

This sample project shows the problem I encountered in action. When you display the modal window by way of a `dispatch_async(dispatch_get_main_queue(), ^{})` call, additional blocks that should execute in the main queue do not execute when dispatched from the modal window. Note, however, this is not a problem when the modal window is presented from the main thread without using `dispatch_async(dispatch_get_main_queue(), ^{})`.

[1]: http://www.thecave.com/2015/08/10/dispatch-async-to-main-queue-doesnt-work-with-modal-window-on-mac-os-x/
[mikeash]: https://mikeash.com/pyblog/
