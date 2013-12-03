//
//  NewViewController.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitialSlidingViewController.h"
#import "MDCParallaxView.h"
#import "SundownWrapper.h"
#import "DTCoreText.h"
#import "ManagedNew.h"
@interface NewViewController : UIViewController<UIActionSheetDelegate,UIActionSheetDelegate, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
@property(strong, nonatomic)New *currentDicoNew;
@property (strong, nonatomic) IBOutlet UINavigationItem *titleNew;
@property(strong, nonatomic) IBOutlet UIImageView *imageNew;
@property(strong,nonatomic) IBOutlet UIView *contentView;
@property(strong,nonatomic) IBOutlet UITextView *textViewTitle;
@property(strong,nonatomic) IBOutlet UITextView *test;
@property(strong, nonatomic) IBOutlet UIImageView *imageAuthor;
@property(strong, nonatomic) IBOutlet UIButton *btnBack;
@property(strong, nonatomic) IBOutlet DTAttributedTextView *textView;
@property(strong,nonatomic) IBOutlet UILabel *dateLabel;

@end
