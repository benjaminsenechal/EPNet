//
//  LessonViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "LessonViewController.h"

@interface LessonViewController ()<UIScrollViewDelegate>

@end

@implementation LessonViewController
@synthesize currentDicoLesson;
@synthesize contentView;
@synthesize imageAuthor;
@synthesize textViewTitle;
@synthesize imageLesson;
@synthesize textView;
@synthesize backButton;
@synthesize dateLabel;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    NSString *myString = currentDicoLesson.created_at;
    NSArray *myWords = [myString componentsSeparatedByString:@"T"];
    NSString *date = [myWords objectAtIndex:0];
    NSArray *myDate = [date componentsSeparatedByString:@"-"];
    NSString *a = [myDate objectAtIndex:0];
    NSString *m = [myDate objectAtIndex:1];
    NSString *j = [myDate objectAtIndex:2];
    NSString *str = [NSString stringWithFormat: @"%@/%@/%@", j, m,a];
  
    dateLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    dateLabel.text = str;
    [dateLabel setFont:FONT(14)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [dateLabel setTextColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.00]];

    
    UIImage *redButtonImage = [UIImage imageNamed:@"back"];
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20.0, 40.0, 15.0, 25.0);
    [backButton setBackgroundImage:redButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    imageAuthor = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-35, -25, 70, 70)];
    [imageAuthor setImage:[UIImage imageWithData:currentDicoLesson.member.avatarThumb]];
    imageAuthor.layer.cornerRadius = 35;
    imageAuthor.layer.masksToBounds = YES;
    
    imageLesson = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 320, 178)];
    [imageLesson  setImage:[UIImage imageWithData:currentDicoLesson.imageThumb]];
    imageLesson.contentMode = UIViewContentModeScaleAspectFill;
    [imageLesson addSubview:backButton];

  //  NSString *html = [SundownWrapper convertMarkdownString:currentDicoLesson.content];
   // NSData *HTMLData = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
    
    textView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0.0, 100.0, self.view.frame.size.width, self.view.frame.size.height)];
    CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height);
    
    NSDictionary *options = @{ DTDefaultFontFamily : @"Myriad Pro",
                               DTDefaultFontSize : [NSNumber numberWithFloat:13.0],
                               DTDefaultLinkColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1],
                               DTMaxImageSize : [NSValue valueWithCGSize:maxImageSize],
                               };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:currentDicoLesson.content options:options documentAttributes:nil];

    textView.attributedString = attrString;
	textView.shouldDrawImages = YES;
	textView.shouldDrawLinks = YES;
    textView.textDelegate = self;
    [textView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 44, 0)];
	textView.contentInset = UIEdgeInsetsMake(10, 10, 0, 10);
	//textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [textView.attributedTextContentView setNeedsDisplay];
    [textView setScrollEnabled:NO];
    
    textViewTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, 55, self.view.frame.size.width, 40)];
    textViewTitle.text = currentDicoLesson.title;
    textViewTitle.font = FONT(20);
    [textViewTitle setTextColor:[UIColor colorWithRed:82.0/255.0 green:88.0/255.0 blue:99.0/255.0 alpha:1]];
    textViewTitle.editable = NO;
    textViewTitle.textAlignment = NSTextAlignmentCenter;
 
    [contentView addSubview:textView];
    [contentView addSubview:textViewTitle];
    [contentView addSubview:dateLabel];
    [contentView addSubview:imageAuthor];
    
    MDCParallaxView *parallaxView = [[MDCParallaxView alloc] initWithBackgroundView:imageLesson
                                                                     foregroundView:contentView];
    parallaxView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    // parallaxView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    parallaxView.backgroundHeight = 130;
    parallaxView.scrollView.scrollsToTop = YES;
    parallaxView.backgroundInteractionEnabled = YES;
    parallaxView.scrollViewDelegate = self;
    
    [self.view addSubview:parallaxView];
    
    double delayInSeconds1 = 1.0;
    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds1 * NSEC_PER_SEC);
    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
        [self getHeight];
    });
    
}

-(void)getHeight{
    CGRect frame2;
    frame2 = textView.frame;
    frame2.size.height = [textView contentSize].height + 150;
    NSLog(@"%f", frame2.size.height);
    textView.frame = frame2;
    contentView.frame = frame2;
    [self.view setNeedsDisplay];
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    // if the attachment has a hyperlinkURL then this is currently ignored
    DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
    imageView.delegate = self;
    
    CGSize sz = [attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:320.0];
    textView.frame = CGRectMake(0,100,sz.width,sz.height);
    
    // sets the image if there is one
    imageView.image = [(DTImageTextAttachment *)attachment image];

    // url for deferred loading
    imageView.url = attachment.contentURL;
    return imageView;
    
}
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
	NSURL *url = lazyImageView.url;
	CGSize imageSize = size;
	
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
	
	BOOL didUpdate = NO;
	
	// update all attachments that matchin this URL (possibly multiple images with same size)
	for (DTTextAttachment *oneAttachment in [textView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
	{
		// update attachments that have no original size, that also sets the display size
		if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
		{
			oneAttachment.originalSize = imageSize;
			
			didUpdate = YES;
		}
	}
	
	if (didUpdate)
	{
		// layout might have changed due to image sizes
		[textView relayoutText];
	}
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"biblio"]){
        InitialSlidingViewController *nextVC = segue.destinationViewController;
        nextVC.vc = @"Bibliothèque";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backAction:(id)sender {
    [self performSegueWithIdentifier:@"biblio" sender:self];
}
@end
