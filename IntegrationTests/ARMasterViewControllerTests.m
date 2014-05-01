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

// TODO: use shared examples once XCTool next has been released
// see https://github.com/facebook/xctool/issues/273

beforeAll(^{
    setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);
});

__block UIWindow *window;
__block UIDeviceOrientation deviceOrientation;

describe(@"portrait", ^{
    beforeEach(^{
        deviceOrientation = UIDeviceOrientationPortrait;
        objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), deviceOrientation);
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
        expect(window).will.haveValidSnapshotNamed([NSString stringWithFormat:@"%@/default", @(deviceOrientation)]);
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
                expect(window).will.haveValidSnapshotNamed([NSString stringWithFormat:@"%@/ascii", @(deviceOrientation)]);
                done();
            });
        });
    });
});

describe(@"landscape", ^{
    beforeEach(^{
        deviceOrientation = UIDeviceOrientationLandscapeRight;
        objc_msgSend([UIDevice currentDevice], @selector(setOrientation:), deviceOrientation);
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
        expect(window).will.haveValidSnapshotNamed([NSString stringWithFormat:@"%@/default", @(deviceOrientation)]);
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
                expect(window).will.haveValidSnapshotNamed([NSString stringWithFormat:@"%@/ascii", @(deviceOrientation)]);
                done();
            });
        });
    });
});

SpecEnd
