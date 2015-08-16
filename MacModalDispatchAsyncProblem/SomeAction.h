//
//  SomeAction.h
//  MacModalDispatchAsyncProblem
//
//  Created by Kirby Turner on 8/16/15.
//  Copyright (c) 2015 White Peak Software, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SomeAction : NSObject

- (void)performSomeActionWithCompletion:(void(^)(BOOL success, NSError *error))completion;

@end
