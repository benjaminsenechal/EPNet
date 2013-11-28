//
//  AcceuilViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "AccueilViewController.h"

@interface AccueilViewController ()

@end

@implementation AccueilViewController
@synthesize aProposButton;
@synthesize menuButton;
@synthesize dicoNews;
@synthesize tableViewNews;
@synthesize newsSelected;
@synthesize navBar;
@synthesize loader;
@synthesize dates;
int f=0;

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [self.tableViewNews addSubview:refreshControl];
    
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
    
    if (f == 0) {
        [ManagedMember loadDataFromWebService];
        [ManagedNew loadDataFromWebService];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedLoad) name:@"notificationLoadMembersNewsFinished" object:nil];
        f = 1;
    }else{
        [self finishedLoad];
    }
    [tableViewNews reloadData];

}

- (void)dropViewDidBeginRefreshing:(UIRefreshControl *)refreshControl
{
    [self finishedLoad];
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}

-(void)finishedLoad{
    New *n;
    dicoNews = [New findAllSortedBy:@"created_at" ascending:NO];
    for (int i = 0; i < [dicoNews count]; i++) {
        n =  [dicoNews objectAtIndex:i];
        NSLog(@"Les News %@ - %@", n.title, n.member.lastname);
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"notificationLoadMembersNewsFinished" object:nil];
    [tableViewNews reloadData];
    [loader stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    newsSelected = [dicoNews objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"newsSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"newsSegue"]){
        NewViewController *nextVC = segue.destinationViewController;
        nextVC.currentDicoNew = newsSelected;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dicoNews count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomNewsViewCell *tmpCell = [[CustomNewsViewCell alloc] init];
    tmpCell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    New *n = [dicoNews objectAtIndex:indexPath.row];
    NSString *tmpString = n.title;
    [tmpCell.titleNews setText:[NSString stringWithFormat:@"%@",tmpString]];
    tmpCell.titleNews.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:0.9];

    [tmpCell.newsImage setImage:[UIImage imageWithData:n.imageThumbRect]];

    return tmpCell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)menuAction:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}
- (IBAction)aProposAction:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECLeft];
}
@end
