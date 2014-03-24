//
//  UIImage+ASCIITests.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/15/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARMasterViewController.h"
#import <ARASCIISwizzle/UIImage+ASCII.h>
#import <FBSnapshotTestCase/UIImage+Compare.h>

SpecBegin(UIImageASCII)

__block UIImage *portraitOfLady = nil;

beforeEach(^{
    portraitOfLady = [UIImage imageNamed:@"Images/rogier-van-der-weyden-portrait-of-a-lady.jpg"];
});

it(@"asciiText", ^{
    expect(portraitOfLady).toNot.beNil();
    NSString *asciiText = portraitOfLady.asciiText;
    expect(asciiText.length).to.equal((32 + 1) * 44);
    expect([asciiText substringToIndex:5]).to.equal(@"*****");
});

it(@"asciiImage", ^{
    expect(portraitOfLady).toNot.beNil();
    UIImage *asciiImage = [portraitOfLady asciiImage:[UIFont fontWithName:@"Courier New" size:12.0f] color:[UIColor yellowColor]];
    expect(asciiImage).toNot.beNil();

    // NSData *asciiImageData = UIImagePNGRepresentation(asciiImage);
    // NSString *referenceImagePath2x = [NSString stringWithFormat:@"%@/UIImageASCII/ascii@2x.png", @(FB_REFERENCE_IMAGE_DIR)];
    // [asciiImageData writeToFile:referenceImagePath2x options:NSDataWritingAtomic error:nil];

    NSString *referenceImagePath = [NSString stringWithFormat:@"%@/UIImageASCII/ascii.png", @(FB_REFERENCE_IMAGE_DIR)];
    UIImage *referenceImage = [UIImage imageWithContentsOfFile:referenceImagePath];
    expect([asciiImage compareWithImage:referenceImage]).to.beTruthy();
});

SpecEnd
