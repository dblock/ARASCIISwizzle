//
//  OCMockObject+VerifyWithDelay.h
//  Tests
//
//  Created by Daniel Doubrovkine on 3/26/14.
//
//

#import "OCMockObject.h"

@interface OCMockObject (VerifyWithDelay)
- (void)verifyWithDelay:(NSTimeInterval)delay;
- (void)verifyAfterDelay:(NSTimeInterval)delay;
@end
