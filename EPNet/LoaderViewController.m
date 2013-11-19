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
Thematic *n;
@synthesize dicoLessons;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
   // [ManagedLesson loadDataFromWebService];
   // [ManagedThematic loadDataFromWebService];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestWSFinishedReloadTB) name:@"finishLoadThematicFromWS" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dicoLessons = [Lesson findAllSortedBy:@"title" ascending:YES];
    NSLog(@"TitreLessons %@", [dicoLessons valueForKey:@"title"]);
    
    NSArray *dicoT = [Thematic findAllSortedBy:@"title" ascending:YES];
    NSLog(@"TitreThematic %@", [dicoT valueForKey:@"title"]);
    for (int i = 0; i < [dicoT count]; i++) {
        n =  [dicoT objectAtIndex:i];
        NSSet *nn = n.lesson;
        NSArray *test  = [nn allObjects];
        NSLog(@"%@", [test valueForKey:@"title"]);
        for (int i =0; i< [test count]; i++){
             NSLog(@"them:%@ - lessons:%@", n.title ,[[test valueForKey:@"title"]objectAtIndex:i] );
        }
    }
    
}
-(void)requestWSFinishedReloadTB{
    NSLog(@"bordel");

           
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"finishLoadThematicFromWS" object:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
