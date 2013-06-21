//
//  InitialSlidingViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "InitialSlidingViewController.h"

@interface InitialSlidingViewController ()

@end

@implementation InitialSlidingViewController
@synthesize vc;
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if (vc == NULL){
        vc = @"Acceuil";
    }
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:vc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
