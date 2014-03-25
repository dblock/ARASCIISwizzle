//
//  UIFont+ASCIITests.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/15/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import <ARASCIISwizzle/UIFont+ASCII.h>

SpecBegin(UIFontASCII)

afterEach(^{
    UIFont.ascii = NO;
});

it(@"no", ^{
    UIFont.ascii = NO;
    expect(UIFont.ascii).to.beFalsy();
    expect([UIFont fontWithName:@"Helvetica" size:12].fontName).to.equal(@"Helvetica");
});

it(@"yes", ^{
    UIFont.ascii = YES;
    expect(UIFont.ascii).to.beTruthy();
    expect([UIFont fontWithName:@"Helvetica" size:12].fontName).to.equal(@"Courier New");
});

SpecEnd
