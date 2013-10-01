//
//  ViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 17/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end
@implementation ViewController
@synthesize less;
@synthesize hey;

-(void)requestWSFinishedReloadTB
{
    NSLog(@"Reload");
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"finishLoadFromWS" object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Thematic" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    less = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Thematic" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    less = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i = 0; i < [less count]; i++) {
        Thematic *n =  [less objectAtIndex:i];
        NSSet *nn = n.lesson;
        NSArray *test  = [nn allObjects];
        for (int i =0; i< [test count]; i++){
            NSLog(@"them:%@ - lessons:%@", n.title ,[[test valueForKey:@"title"]objectAtIndex:i] );
        }
    }

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestWSFinishedReloadTB) name:@"finishLoadFromWS" object:nil];

    [ManagedMember loadDataFromWebService];
    [ManagedLesson loadDataFromWebService];
    [ManagedThematic loadDataFromWebService];
    [ManagedNew loadDataFromWebService];
    [ManagedProject loadDataFromWebService];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
