//
//  LessonViewController.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ManagedMember.h"
#import "ManagedNew.h"
#import "ManagedThematic.h"
#import "ManagedProject.h"
#import "ManagedLesson.h"
#import "ECSlidingViewController.h"
#import "InitialSlidingViewController.h"
#import "MenuViewController.h"
#import "aProposViewController.h"
#import "MDCParallaxView.h"
#import "SundownWrapper.h"
#import "DTCoreText.h"

@interface LessonViewController : UIViewController<UIActionSheetDelegate,UIActionSheetDelegate, DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
@property(strong, nonatomic) IBOutlet UIImageView *imageLesson;
@property(strong,nonatomic) IBOutlet UIView *contentView;
@property(strong,nonatomic) IBOutlet UITextView *textViewTitle;
@property(strong, nonatomic) IBOutlet UIImageView *imageAuthor;
@property(strong, nonatomic)Lesson *currentDicoLesson;
@property(strong, nonatomic) IBOutlet  DTAttributedTextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end
