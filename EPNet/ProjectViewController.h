//
//  ProjectViewController.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 21/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "AProposViewController.h"
#import "AppDelegate.h"
#import "ManagedMember.h"
#import "ManagedNew.h"
#import "ManagedThematic.h"
#import "ManagedProject.h"
#import "CustomProjetCell.h"
@interface ProjectViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
- (IBAction)menuAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *aProposButton;
- (IBAction)aProposAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableViewProjets;
@property (strong, nonatomic) IBOutlet NSArray *dicoProjets;

@end
