//
//  UIImage+ASCIITests.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/15/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import <ARASCIISwizzle/UIImage+ASCII.h>
#import <FBSnapshotTestCase/UIImage+Compare.h>

SpecBegin(UIImageASCII)

__block UIImage *portraitOfLady = nil;

beforeEach(^{
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"rogier-van-der-weyden-portrait-of-a-lady" ofType:@"jpg"];
    portraitOfLady = [UIImage imageWithContentsOfFile:imagePath];
});

it(@"asciiText", ^{
    expect(portraitOfLady).toNot.beNil();
    NSString *asciiText = portraitOfLady.asciiText;
    expect(asciiText.length).to.equal((32 + 1) * 44);
    expect([asciiText substringToIndex:5]).to.equal(@"*****");
});

// TODO: https://github.com/dblock/ARASCIISwizzle/issues/4
pending(@"asciiImage", ^{
    expect(portraitOfLady).toNot.beNil();
    UIImage *asciiImage = [portraitOfLady asciiImage:[UIFont fontWithName:@"Courier New" size:12.0f] color:[UIColor yellowColor]];
    expect(asciiImage).toNot.beNil();

    NSString *referenceImagePath2x = [NSString stringWithFormat:@"%@/UIImageASCII/ascii@2x.png", @(FB_REFERENCE_IMAGE_DIR)];
    
    // NSData *asciiImageData = UIImagePNGRepresentation(asciiImage);
    // [asciiImageData writeToFile:referenceImagePath2x options:NSDataWritingAtomic error:nil];

    UIImage *referenceImage = [UIImage imageWithContentsOfFile:referenceImagePath2x];
    expect([asciiImage compareWithImage:referenceImage]).to.beTruthy();
});

SpecEnd
