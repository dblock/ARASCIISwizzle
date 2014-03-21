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

@interface ARMasterViewController ()
@property(nonatomic, strong, readonly) ORStackView *view;
@end

@implementation ARMasterViewController

- (void)loadView
{
    self.view = [[ORStackView alloc] init];
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *portraitOfLady = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Images/rogier-van-der-weyden-portrait-of-a-lady.jpg"]];
    portraitOfLady.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:portraitOfLady withTopMargin:@"160"];
    [portraitOfLady alignCenterXWithView:self.view predicate:@"0"];
    [portraitOfLady alignCenterYWithView:self.view predicate:@"0"];
    [portraitOfLady constrainWidth:@"200"];
    
    UILabel *portraitOfLadyTitle = [[UILabel alloc] init];
    [self.view addSubview:portraitOfLadyTitle withTopMargin:@"10"];
    portraitOfLadyTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    portraitOfLadyTitle.text = @"ROGIER VAN DER WEYDEN";
    [portraitOfLadyTitle alignCenterXWithView:self.view predicate:@"0"];

    UILabel *portraitOfLadySubtitle = [[UILabel alloc] init];
    [self.view addSubview:portraitOfLadySubtitle withTopMargin:@"5"];
    portraitOfLadySubtitle.font = [UIFont fontWithName:@"HelveticaNeue" size:8];
    portraitOfLadySubtitle.text = @"Portrait of a Lady, ca. 1460\nNational Gallery of Art, Washington DC";
    [portraitOfLadySubtitle alignCenterXWithView:self.view predicate:@"0"];
    
    UIButton *toggle = [[UIButton alloc] init];
    [self.view addSubview:toggle withTopMargin:@"20"];
    [toggle setTitle:@"Toggle" forState:UIControlStateNormal];
    [toggle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    toggle.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    toggle.layer.borderWidth = 1.0f;
    toggle.layer.borderColor = [[UIColor blackColor] CGColor];
    [toggle constrainWidth:@"120" height:@"40"];
    [toggle alignCenterXWithView:self.view predicate:@"0"];
    [toggle addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)toggle:(id)sender
{
    UIFont.ascii = ! UIFont.ascii;
    UIImageView.ascii = ! UIImageView.ascii;
    
    [self loadView];
    [self viewDidLoad];
}

@end
