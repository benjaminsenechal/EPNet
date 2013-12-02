//
//  MenuViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation MenuViewController

@synthesize menuItems;

- (void)awakeFromNib
{
    self.menuItems = [NSArray arrayWithObjects:@"", @"Accueil",@"Bibliothèque",@"Équipe",@"Projets", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.slidingViewController setAnchorRightRevealAmount:250.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    return self.menuItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"MyriadPro-Regular" size:17.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1]];
    if([[self.menuItems objectAtIndex:indexPath.row] isEqual:@""]){
        [bgColorView setBackgroundColor:[UIColor colorWithRed:12.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1]];
    }
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menuItems objectAtIndex:indexPath.row]];
    UIViewController *newTopViewController;
    if ([identifier isEqualToString:@""]){
        newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Accueil"];
    }else{
         newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    }
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
