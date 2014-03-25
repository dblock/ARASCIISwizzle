//
//  UIImageView+ASCIITests.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/15/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import <ARASCIISwizzle/UIImageView+ASCII.h>

SpecBegin(UIImageViewASCII)

afterEach(^{
    UIImageView.ascii = NO;
});

it(@"no", ^{
    UIImageView.ascii = NO;
    expect(UIImageView.ascii).to.beFalsy();
});

it(@"yes", ^{
    UIImageView.ascii = YES;
    expect(UIImageView.ascii).to.beTruthy();
});

SpecEnd
