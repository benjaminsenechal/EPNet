//
//  BibliothequeViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "BibliothequeViewController.h"

@interface BibliothequeViewController ()

@end

@implementation BibliothequeViewController
@synthesize aProposButton;
@synthesize menuButton;
@synthesize tableViewThematic;
@synthesize themSelected;
@synthesize lessonSelected;
@synthesize dicoLessons;
Thematic *n;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor darkGrayColor],
                          UITextAttributeTextShadowColor: [UIColor whiteColor],
                                     UITextAttributeFont: [UIFont fontWithName:@"HelveticaNeue-Light" size:20.0f]
     }];
    
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
                                   entityForName:@"Thematic" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    dicoLessons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [tableViewThematic reloadData];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Data manage
  //  [ManagedThematic loadDataFromWebService];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Thematic" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    dicoLessons = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i = 0; i < [dicoLessons count]; i++) {
        n =  [dicoLessons objectAtIndex:i];
        NSSet *nn = n.lesson;
        NSArray *test  = [nn allObjects];

        for (int i =0; i< [test count]; i++){
          // NSLog(@"them:%@ - lessons:%@", n.title ,[[test valueForKey:@"title"]objectAtIndex:i] );
        }
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestWSFinishedReloadTB) name:@"finishLoadFromWS" object:nil];
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    themSelected = [dicoLessons objectAtIndex:indexPath.section];
    NSSet *nn = themSelected.lesson;
    NSArray *test  = [nn allObjects];
    lessonSelected = [test objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"lessonSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"lessonSegue"]){
        LessonViewController *nextVC = segue.destinationViewController;
       nextVC.currentDicoLesson = lessonSelected;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    n =  [dicoLessons objectAtIndex:section];
    return n.title ;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dicoLessons count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int r;
    for (int i = 0; i < [dicoLessons count]; i++) {
        n =  [dicoLessons objectAtIndex:section];
        NSSet *nn = n.lesson;
        NSArray *test  = [nn allObjects];
        r= [test count];
    }
    return r;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomBibliothequeCell *Cell = [[CustomBibliothequeCell alloc] init];
    Cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    for (int i = 0; i < [dicoLessons count]; i++) {
        Thematic *n = [dicoLessons objectAtIndex:indexPath.section];
        NSSet *nn = n.lesson;
        NSString *tmpString;
        NSArray *test  = [nn allObjects];
        tmpString = [[test valueForKey:@"title"]objectAtIndex:indexPath.row];
        [Cell.labelName setText:[NSString stringWithFormat:@"%@",tmpString]];
        [Cell.imageLessons setImage:[UIImage imageWithData:[[test valueForKey:@"imageThumbRect"]objectAtIndex:indexPath.row]]];
    }
    Cell.labelName.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:0.9];
    
    return Cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f]];
    label.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];
    label.text = sectionTitle;
    [view addSubview:label];
    
    return view;
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
