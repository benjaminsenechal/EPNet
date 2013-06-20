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

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIStoryboard *storyboard;
    storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Acceuil"];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
