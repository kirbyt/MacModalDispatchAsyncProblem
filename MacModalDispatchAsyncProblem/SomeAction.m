//
//  SomeAction.m
//  MacModalDispatchAsyncProblem
//
//  Created by Kirby Turner on 8/16/15.
//  Copyright (c) 2015 White Peak Software, Inc. All rights reserved.
//

#import "SomeAction.h"

@implementation SomeAction

- (void)performSomeActionWithCompletion:(void(^)(BOOL success, NSError *error))completion
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // Do some work here. For fun, let's hit a web site.
    NSURL *URL = [NSURL URLWithString:@"http://www.apple.com"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    BOOL success = [data length] > 0;
    if (completion) {
      completion(success, error);
    }
  });
}

@end
