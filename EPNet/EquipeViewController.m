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
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [self.tableViewMember addSubview:refreshControl];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor darkGrayColor],
                          UITextAttributeTextShadowColor: [UIColor whiteColor],
                                     UITextAttributeFont: FONT(20)
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
    [self finishedLoad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)finishedLoad{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"client = 'false'"];
    dicoMember = [Member findAllSortedBy:@"idMember" ascending:YES withPredicate:predicate];
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tableViewMember reloadData];
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dicoMember count];
}

- (void)dropViewDidBeginRefreshing:(UIRefreshControl *)refreshControl
{
    [ManagedMember persistMember];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
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
    [Cell.labelFirst setFont:FONT(16)];
    
    [Cell.labelRole setText:n.role];
    [Cell.labelRole setFont:FONT(16)];
    
    Cell.label.font = [UIFont systemFontOfSize:14];
    Cell.label.numberOfLines = 0;
    if ([[[dicoMember valueForKey:@"desc"]objectAtIndex:indexPath.row]isEqual:@"null"]){
        Cell.label.text = @"";
    }else{
        Cell.label.text = [[dicoMember valueForKey:@"desc"]objectAtIndex:indexPath.row];
    }
    [Cell.label setFont:FONT(14)];
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
