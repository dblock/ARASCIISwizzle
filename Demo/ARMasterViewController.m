//
//  ARMasterViewController.m
//  ARASCIISwizzle
//
//  Created by Daniel Doubrovkine on 3/10/14.
//  Copyright (c) 2014 Artsy. All rights reserved.
//

#import "ARMasterViewController.h"
#import <QuartzCore/QuartzCore.h>

#import <ARASCIISwizzle/UIFont+ASCII.h>
#import <ARASCIISwizzle/UIImageView+ASCII.h>

@implementation ARMasterViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *portraitOfLadyImage = [UIImage imageNamed:@"Images/rogier-van-der-weyden-portrait-of-a-lady.jpg"];
    UIImageView *portraitOfLady = [[UIImageView alloc] initWithImage:portraitOfLadyImage];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    [self.view addSubview:portraitOfLady];
    CGFloat targetWidth = CGRectGetWidth([UIScreen mainScreen].bounds) * 0.5f;
    [portraitOfLady constrainHeight:[NSString stringWithFormat:@"%@", @(targetWidth / portraitOfLadyImage.size.width * portraitOfLadyImage.size.height)]];
    [portraitOfLady constrainWidth:[NSString stringWithFormat:@"%@", @(targetWidth)]];

    if (UIDeviceOrientationIsPortrait(orientation))
    {
        [portraitOfLady alignCenterXWithView:self.view predicate:@"0"];
        [portraitOfLady alignTopEdgeWithView:self.view predicate:@"100"];
    }
    else
    {
        [portraitOfLady alignLeadingEdgeWithView:self.view predicate:@"100"];
        [portraitOfLady alignTopEdgeWithView:self.view predicate:@"75"];
    }

    UILabel *portraitOfLadyTitle = [[UILabel alloc] init];
    [self.view addSubview:portraitOfLadyTitle];
    portraitOfLadyTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    portraitOfLadyTitle.text = @"ROGIER VAN DER WEYDEN";
    portraitOfLadyTitle.textAlignment = NSTextAlignmentCenter;

    if (UIDeviceOrientationIsPortrait(orientation))
    {
        [portraitOfLadyTitle alignAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofView:portraitOfLady predicate:@"20"];
        [portraitOfLadyTitle alignCenterXWithView:self.view predicate:@"0"];
    }
    else
    {
        [portraitOfLadyTitle alignTopEdgeWithView:self.view predicate:@"100"];
        [portraitOfLadyTitle alignTrailingEdgeWithView:self.view predicate:@"-20"];
        [portraitOfLadyTitle alignAttribute:NSLayoutAttributeLeading toAttribute:NSLayoutAttributeTrailing ofView:portraitOfLady predicate:@"20"];
    }
    
    UILabel *portraitOfLadySubtitle = [[UILabel alloc] init];
    [self.view addSubview:portraitOfLadySubtitle];
    portraitOfLadySubtitle.font = [UIFont fontWithName:@"HelveticaNeue" size:8];
    portraitOfLadySubtitle.text = @"Portrait of a Lady, ca. 1460\nNational Gallery of Art, Washington DC";
    portraitOfLadySubtitle.numberOfLines = 2;
    portraitOfLadySubtitle.textAlignment = NSTextAlignmentCenter;
    [portraitOfLadySubtitle alignAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofView:portraitOfLadyTitle predicate:@"20"];
    [portraitOfLadySubtitle alignCenterXWithView:portraitOfLadyTitle predicate:@"0"];
    
    UIButton *toggle = [[UIButton alloc] init];
    [self.view addSubview:toggle];
    [toggle setTitle:@"Toggle" forState:UIControlStateNormal];
    [toggle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    toggle.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    toggle.layer.borderWidth = 1.0f;
    toggle.layer.borderColor = [[UIColor blackColor] CGColor];
    [toggle constrainWidth:@"120" height:@"40"];
    [toggle alignCenterXWithView:portraitOfLadyTitle predicate:@"0"];
    [toggle addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    [toggle alignAttribute:NSLayoutAttributeTop toAttribute:NSLayoutAttributeBottom ofView:portraitOfLadySubtitle predicate:@"20"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)orientationChanged:(NSNotification *)notification
{
    [self loadView];
    [self viewDidLoad];
}

- (void)toggle:(id)sender
{
    UIFont.ascii = ! UIFont.ascii;
    UIImageView.ascii = ! UIImageView.ascii;
    
    [self loadView];
    [self viewDidLoad];
}

@end
