//
//  ProjectViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 21/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "ProjectViewController.h"

@interface ProjectViewController ()

@end
@implementation ProjectViewController
@synthesize menuButton;
@synthesize aProposButton;
@synthesize tableViewProjets;
@synthesize dicoProjets;
@synthesize loader;
int e=0;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [self.tableViewProjets addSubview:refreshControl];
    
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

    if (e == 0){
        dicoProjets = [Project findAllSortedBy:@"created_at" ascending:NO];
        [ManagedProject loadDataFromWebService];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoad) name:@"notificationLoadProjectFinished" object:nil];
        e=1;
        [tableViewProjets reloadData];
    }else{
        [loader stopAnimating];
        [self finishedLoad];
    }

}

-(void)finishedLoad{
    dicoProjets = [Project findAllSortedBy:@"created_at" ascending:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationLoadProjectFinished" object:nil];
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tableViewProjets reloadData];
    });
    [loader stopAnimating];
}


- (void)dropViewDidBeginRefreshing:(UIRefreshControl *)refreshControl
{
    [ManagedProject loadDataFromWebService];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dicoProjets count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomProjetCell *Cell = [[CustomProjetCell alloc] init];
    Cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    Project *n = [dicoProjets objectAtIndex:indexPath.row];

    [Cell.imageProjet setImage:[UIImage imageWithData:n.imageThumbRect]];
    
    [Cell.labelTitle setText:n.title];
    [Cell.labelTitle setFont:FONT(17)];
    Cell.labelDesc.font = [UIFont systemFontOfSize:14];
    Cell.labelDesc.text = n.desc;
    Cell.labelDesc.numberOfLines = 0;
    [Cell.labelDesc setFont:FONT(14)];
    CGSize size = [n.desc
                   sizeWithFont:[UIFont systemFontOfSize:14]
                   constrainedToSize:CGSizeMake(320, CGFLOAT_MAX)];
    CGRect newFrame = Cell.labelDesc.frame;
    newFrame.size.height = size.height;
    Cell.labelDesc.frame = newFrame;

    return Cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Project *n = [dicoProjets objectAtIndex:indexPath.row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:n.link]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [[[dicoProjets valueForKey:@"desc" ] objectAtIndex:indexPath.row]
                   sizeWithFont:[UIFont systemFontOfSize:14]
                   constrainedToSize:CGSizeMake(320, CGFLOAT_MAX)];
    return size.height + 230;
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
