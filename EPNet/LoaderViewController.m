//
//  LoaderViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 14/11/2013.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "LoaderViewController.h"

@interface LoaderViewController ()

@end

@implementation LoaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadAllData];
}

-(void)loadAllData{
    [ManagedNew loadDataFromWebService];
    [ManagedMember loadDataFromWebService];
    [ManagedLesson loadDataFromWebService];
    [ManagedThematic loadDataFromWebService];
    [ManagedProject loadDataFromWebService];
}

-(void)load{
    NSLog(@"Tout est chargé");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
