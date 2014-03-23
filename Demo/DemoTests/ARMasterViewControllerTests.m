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

SpecBegin(ARMasterViewController)

beforeAll(^{
    setGlobalReferenceImageDir(FB_REFERENCE_IMAGE_DIR);
});

__block UIWindow *window;

beforeEach(^{
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
    expect(vc.view).will.haveValidSnapshotNamed(@"default");
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
            expect(vc.view).will.haveValidSnapshotNamed(@"ascii");
            done();
        });
    });
});

SpecEnd
