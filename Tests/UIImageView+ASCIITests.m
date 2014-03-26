//
//  UIImageView+ASCIITests.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/15/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import <ARASCIISwizzle/UIImageView+ASCII.h>
#import <ARASCIISwizzle/UIImage+ASCII.h>
#import "OCMockObject+VerifyWithDelay.h"

SpecBegin(UIImageViewASCII)

afterEach(^{
    UIImageView.ascii = NO;
});

describe(@"no", ^{
    beforeEach(^{
        UIImageView.ascii = NO;
    });
    
    it(@"toggle", ^{
        expect(UIImageView.ascii).to.beFalsy();
    });

    it(@"does not convert image to ASCII", ^{
        NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"rogier-van-der-weyden-portrait-of-a-lady" ofType:@"jpg"];
        UIImage *portraitOfLady = [UIImage imageWithContentsOfFile:imagePath];
        id imageMock = [OCMockObject partialMockForObject:portraitOfLady];
        [[imageMock reject] asciiImage:OCMOCK_ANY color:OCMOCK_ANY];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:portraitOfLady];
        expect(imageView).toNot.beNil();
        [imageMock verifyAfterDelay:1];
        [imageMock stopMocking];
    });
});

describe(@"yes", ^{
    beforeEach(^{
        UIImageView.ascii = YES;
    });
    
    it(@"toggle", ^{
        expect(UIImageView.ascii).to.beTruthy();
    });
    
    it(@"converts image to ASCII", ^{
        NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"rogier-van-der-weyden-portrait-of-a-lady" ofType:@"jpg"];
        UIImage *portraitOfLady = [UIImage imageWithContentsOfFile:imagePath];
        id imageMock = [OCMockObject partialMockForObject:portraitOfLady];
        [[imageMock expect] asciiImage:OCMOCK_ANY color:OCMOCK_ANY];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:portraitOfLady];
        expect(imageView).toNot.beNil();
        [imageMock verifyWithDelay:1];
        [imageMock stopMocking];
    });
});

SpecEnd
