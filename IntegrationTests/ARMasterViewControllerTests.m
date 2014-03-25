//
//  ARMasterViewControllerTests.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/15/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARMasterViewController.h"
#import <ARASCIISwizzle/UIFont+ASCII.h>
#import <ARASCIISwizzle/UIImageView+ASCII.h>
#import <objc/message.h>

SpecBegin(ARMasterViewController)

NSString *UIDeviceOrientationKey = @"Device Orientation";

beforeAll(^{
    setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);
});

sharedExamplesFor(@"ascii toggle", ^(NSDictionary *data) {
    
    __block UIWindow *window;
    
    beforeEach(^{
        id deviceOrientation = [data valueForKey:UIDeviceOrientationKey];
        objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), [deviceOrientation integerValue]);
        window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    it(@"displays image", ^{
        UIFont.ascii = NO;
        UIImageView.ascii = NO;
        expect(UIFont.ascii).to.beFalsy();
        expect(UIImageView.ascii).to.beFalsy();
        ARMasterViewController *vc = [[ARMasterViewController alloc] init];
        window.rootViewController = vc;
        expect(vc.view).willNot.beNil();
        [window makeKeyAndVisible];
        expect(window).will.haveValidSnapshotNamed([NSString stringWithFormat:@"%@/default", [data valueForKey:UIDeviceOrientationKey]]);
    });
    
    it(@"switches to ascii", ^AsyncBlock{
        UIFont.ascii = YES;
        UIImageView.ascii = YES;
        expect(UIFont.ascii).to.beTruthy();
        expect(UIImageView.ascii).to.beTruthy();
        ARMasterViewController *vc = [[ARMasterViewController alloc] init];
        window.rootViewController = vc;
        expect(vc.view).willNot.beNil();
        [window makeKeyAndVisible];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [NSThread sleepForTimeInterval:1.0];
            dispatch_async(dispatch_get_main_queue(), ^{
                expect(window).will.haveValidSnapshotNamed([NSString stringWithFormat:@"%@/ascii", [data valueForKey:UIDeviceOrientationKey]]);
                done();
            });
        });
    });
});

itShouldBehaveLike(@"ascii toggle", @{ UIDeviceOrientationKey : @(UIInterfaceOrientationPortrait) });
itShouldBehaveLike(@"ascii toggle", @{ UIDeviceOrientationKey : @(UIInterfaceOrientationLandscapeLeft) });

SpecEnd
