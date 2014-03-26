//
//  OCMockObject+VerifyWithDelay.m
//  Tests
//
//  Created by Daniel Doubrovkine on 3/26/14.
//
//

#import "OCMockObject+VerifyWithDelay.h"

@implementation OCMockObject (VerifyWithDelay)

- (void)verifyWithDelay:(NSTimeInterval)delay {
    NSTimeInterval i = 0;
    while (i < delay) {
        @try {
            [self verify];
            return;
        } @catch (NSException *e) {}
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        i += 0.5;
    }
    
    [self verify];
}

- (void)verifyAfterDelay:(NSTimeInterval)delay {
    NSTimeInterval i = 0;
    while (i < delay) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
        i += 0.5;
    }

    [self verify];
}

@end
