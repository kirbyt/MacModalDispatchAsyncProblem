//
//  AppDelegate.m
//  MacModalDispatchAsyncProblem
//
//  Created by Kirby Turner on 8/16/15.
//  Copyright (c) 2015 White Peak Software, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "SomeModalAlert.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
  // Insert code here to tear down your application
}

- (IBAction)presentModalAlert:(id)sender
{
  SomeModalAlert *alert = [[SomeModalAlert alloc] init];
  [alert runModalWithCompletionHandler:^(BOOL success) {
    NSLog(@"All done.");
  }];
}

- (IBAction)presentModalAlertWithProblem:(id)sender
{
  // Dispatching the display of the alert will cause the alert
  // window to no receive events from other async dispatch
  // requests. To see this in action, click the "Use dispatch_async"
  // button in the alert.
  dispatch_async(dispatch_get_main_queue(), ^{
    SomeModalAlert *alert = [[SomeModalAlert alloc] init];
    [alert runModalWithCompletionHandler:^(BOOL success) {
      NSLog(@"All done.");
    }];
  });
}

@end
