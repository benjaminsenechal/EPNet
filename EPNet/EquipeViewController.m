//
//  EquipeViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "EquipeViewController.h"

@interface EquipeViewController ()

@end

@implementation EquipeViewController
@synthesize menuButton;
@synthesize aProposButton;
@synthesize dicoMember;
@synthesize tableViewMember;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor darkGrayColor],
                          UITextAttributeTextShadowColor: [UIColor whiteColor],
                                     UITextAttributeFont: [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f]
     }];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    if (![self.slidingViewController.underRightViewController isKindOfClass:[AProposViewController class]]) {
        self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"A Propos"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    self.view.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];
    
    // Set images to btn
    UIImage *img =  [UIImage imageNamed:@"btnTop.png"];
    CGRect framImg = CGRectMake(0, 0, img.size.width, img.size.height);
    UIButton *myBtn = [[UIButton alloc] initWithFrame:framImg];
    [myBtn setBackgroundImage:img forState:UIControlStateNormal];
    [myBtn addTarget:self action:@selector(menuAction:)
    forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [menuButton initWithCustomView:myBtn];
    
    UIImage *imgRight =  [UIImage imageNamed:@"logo.png"];
    CGRect framImgRight = CGRectMake(0, 0, (imgRight.size.width)/4, (imgRight.size.height)/4);
    UIButton *myBtnRight = [[UIButton alloc] initWithFrame:framImgRight];
    [myBtnRight setBackgroundImage:imgRight forState:UIControlStateNormal];
    [myBtnRight addTarget:self action:@selector(aProposAction:)
         forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [aProposButton initWithCustomView:myBtnRight];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    
}
-(void)requestWSFinishedReloadTB
{
    NSLog(@"Reload");
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"finishLoadFromWS" object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Member" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];

    NSError *error;
    dicoMember = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

   [tableViewMember reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Data manage
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Member" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;

    dicoMember = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i = 0; i < [dicoMember count]; i++) {
         Member *ne =  [dicoMember objectAtIndex:i];
        NSLog(@"member : %@", ne.idMember);
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestWSFinishedReloadTB) name:@"finishLoadFromWS" object:nil];

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dicoMember count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomEquipeCell *Cell = [[CustomEquipeCell alloc] init];
    Cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    Member *n = [dicoMember objectAtIndex:indexPath.row];
    [Cell.imageMember setImage:[UIImage imageWithData:n.avatarThumb]];
    Cell.imageMember.layer.cornerRadius = 35;
    Cell.imageMember.layer.masksToBounds = YES;
    NSString *string = [NSString stringWithFormat:@"%@ %@", n.firstname, n.lastname];
    [Cell.labelFirst setText:string];
    
    [Cell.labelRole setText:n.role];
    Cell.label.font = [UIFont systemFontOfSize:14];
    Cell.label.numberOfLines = 0;
    if ([[[dicoMember valueForKey:@"desc"]objectAtIndex:indexPath.row]isEqual:@"null"]){
        Cell.label.text = @"";
    }else{
        Cell.label.text = [[dicoMember valueForKey:@"desc"]objectAtIndex:indexPath.row];
    }
    [Cell.label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f]];
    CGSize size = [n.desc
                   sizeWithFont:[UIFont systemFontOfSize:14]
                   constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    CGRect newFrame = Cell.label.frame;
    newFrame.size.height = size.height;
    Cell.label.frame = newFrame;
    
    return Cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [[[dicoMember valueForKey:@"desc" ] objectAtIndex:indexPath.row]
                   sizeWithFont:[UIFont systemFontOfSize:14]
                   constrainedToSize:CGSizeMake(300, CGFLOAT_MAX)];
    return size.height + 150;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)menuAction:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}
- (IBAction)aProposAction:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}

@end
