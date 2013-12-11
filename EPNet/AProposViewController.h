//
//  AProposViewController.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface AProposViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scroll;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *aProposBtn;
@property(strong, nonatomic) IBOutlet UIImageView *logo;
@property(strong, nonatomic) IBOutlet UITextView *textDescription;
@property(strong, nonatomic) IBOutlet UILabel *labelSite;
@property(strong, nonatomic) IBOutlet UILabel *labelContact;
@property(strong, nonatomic) IBOutlet UITextView *textAdress;
@property(strong, nonatomic) IBOutlet UIImageView *imageMap;
@property(strong, nonatomic) IBOutlet UILabel *labelTelNumber;
@property(strong, nonatomic) IBOutlet UILabel *labelSuivezNous;
@property(strong, nonatomic) IBOutlet UILabel *labelTwitter;
@property(strong, nonatomic) IBOutlet UILabel *labelGithub;

- (IBAction)lienEPnet:(id)sender;
- (IBAction)aPropos:(id)sender;
@end
