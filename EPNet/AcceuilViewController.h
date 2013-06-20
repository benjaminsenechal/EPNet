//
//  AcceuilViewController.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
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
#import "CustomNewsViewCell.h"
#import "NewViewController.h"
@interface AcceuilViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
- (IBAction)menuAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *aProposButton;
- (IBAction)aProposAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableViewNews;
@property(strong, nonatomic)NSArray *dicoNews;
@property(strong, nonatomic)New *newsSelected;

@end
