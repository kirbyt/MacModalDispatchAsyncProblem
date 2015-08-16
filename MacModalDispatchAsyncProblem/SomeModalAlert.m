//
//  SomeModalAlert.m
//  MacModalDispatchAsyncProblem
//
//  Created by Kirby Turner on 8/16/15.
//  Copyright (c) 2015 White Peak Software, Inc. All rights reserved.
//

#import "SomeModalAlert.h"
#import "SomeAction.h"

@interface SomeModalAlert ()

@end

@implementation SomeModalAlert

- (instancetype)init
{
  self = [super initWithWindowNibName:@"SomeModalAlert"];
  if (self) {
  }
  return self;
}

- (void)windowDidLoad
{
  [super windowDidLoad];
  [[self window] setTitle:NSLocalizedString(@"Some Modal Alert", @"Window title.")];
}

- (void)runModalWithCompletionHandler:(void (^)(BOOL success))completion
{
  NSInteger modalCode = [NSApp runModalForWindow:[self window]];
  
  if (completion)
  {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      completion(modalCode == NSAlertFirstButtonReturn);
    });
  }
}

- (void)presentOkayAlertWithMessageText:(NSString *)messageText informativeText:(NSString *)informativeText
{
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText:messageText];
  if (informativeText) {
    [alert setInformativeText:informativeText];
  }
  [alert addButtonWithTitle:NSLocalizedString(@"OK", nil)];
  
  NSWindow *window = [self window];
  [alert beginSheetModalForWindow:window completionHandler:nil];
}

#pragma mark - Actions

- (IBAction)close:(id)sender
{
  [NSApp stopModalWithCode:NSAlertFirstButtonReturn];
}

- (IBAction)useDispatchAsync:(id)sender
{
  __weak __typeof__(self) weakSelf = self;
  SomeAction *someAction = [[SomeAction alloc] init];
  [someAction performSomeActionWithCompletion:^(BOOL success, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      NSString *message = NSLocalizedString(@"Success", nil]);
      if (success == NO) {
        message = NSLocalizedString(@"Failure", nil);
      }
      __typeof__(self) strongSelf = weakSelf;
      [strongSelf presentOkayAlertWithMessageText:message informativeText:[error localizedDescription]];
    });
  }];
}

- (IBAction)usePerformSelector:(id)sender
{
  __weak __typeof__(self) weakSelf = self;
  SomeAction *someAction = [[SomeAction alloc] init];
  [someAction performSomeActionWithCompletion:^(BOOL success, NSError *error) {
    // This window is running modally with its own run loop. Therefore,
    // we cannot dispatch to the main queue. Instead, we must go old
    // school can call a selector on the main thread. In other words,
    // dispatch_async(dispatch_get_main_queue(), ^{}); does not work
    // here.
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"success"] = @(success);
    if (error) userInfo[@"error"] = error;
    
    __typeof__(self) strongSelf = weakSelf;
    [strongSelf performSelectorOnMainThread:@selector(checkTheResults:) withObject:userInfo waitUntilDone:NO];
  }];
}

- (void)checkTheResults:(NSDictionary *)userInfo
{
  BOOL success = [userInfo[@"success"] boolValue];
  NSError *error = userInfo[@"error"];
  
  NSString *message = NSLocalizedString(@"Success", nil]);
  if (success == NO) {
    message = NSLocalizedString(@"Failure", nil);
  }
  [self presentOkayAlertWithMessageText:message informativeText:[error localizedDescription]];
}
@end
