//
//  SomeModalAlert.h
//  MacModalDispatchAsyncProblem
//
//  Created by Kirby Turner on 8/16/15.
//  Copyright (c) 2015 White Peak Software, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SomeModalAlert : NSWindowController

- (void)runModalWithCompletionHandler:(void (^)(BOOL success))completion;

@end
