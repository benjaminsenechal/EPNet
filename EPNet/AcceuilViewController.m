//
//  AcceuilViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "AcceuilViewController.h"

@interface AcceuilViewController ()

@end

@implementation AcceuilViewController
@synthesize aProposButton;
@synthesize menuButton;
@synthesize dicoNews;
@synthesize tableViewNews;
@synthesize newsSelected;
@synthesize navBar;
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
                                   entityForName:@"New" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    dicoNews = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [tableViewNews reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Data manage
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"New" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    dicoNews = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i = 0; i < [dicoNews count]; i++) {
       // New *ne =  [dicoNews objectAtIndex:i];
       // NSLog(@"member : %@", ne.member.avatarThumb);
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestWSFinishedReloadTB) name:@"finishLoadFromWS" object:nil];
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
  //  [tmpCell.titleNews setText:n.title];
  //  [tmpCell.dateNews setText:n.created_at];
    [tmpCell.newsImage setImage:[UIImage imageWithData:n.imageThumbRect]];

    return tmpCell;
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
