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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    imageAuthor = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-40, -55, 70, 70)];
    [imageAuthor setImage:[UIImage imageWithData:currentDicoLesson.member.avatarThumb]];
    imageAuthor.layer.cornerRadius = 35;
    imageAuthor.layer.masksToBounds = YES;
    
    imageLesson = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 320, 178)];
    [imageLesson  setImage:[UIImage imageWithData:currentDicoLesson.imageThumb]];
    imageLesson.contentMode = UIViewContentModeScaleAspectFill;
    
  //  NSString *html = [SundownWrapper convertMarkdownString:currentDicoLesson.content];
   // NSData *HTMLData = [html dataUsingEncoding:NSUTF8StringEncoding];

    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
    textView = [[DTAttributedTextView alloc] initWithFrame:CGRectMake(0.0, 80.0, self.view.frame.size.width, self.view.frame.size.height)];
    CGSize maxImageSize = CGSizeMake(self.view.bounds.size.width - 20.0, self.view.bounds.size.height);
    
    NSDictionary *options = @{ DTDefaultFontFamily : @"Helvetica",
                               DTDefaultFontSize : [NSNumber numberWithFloat:14.0],
                               DTDefaultLinkColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1],
                               DTMaxImageSize : [NSValue valueWithCGSize:maxImageSize],
                               };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:currentDicoLesson.content options:options documentAttributes:nil];
    NSLog(@"%@",attrString);
    textView.attributedString = attrString;
	textView.shouldDrawImages = YES;
	textView.shouldDrawLinks = YES;
    textView.textDelegate = self;
    [textView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, 44, 0)];
	textView.contentInset = UIEdgeInsetsMake(10, 10, 0, 10);
	//textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [textView.attributedTextContentView setNeedsDisplay];
    [textView setScrollEnabled:NO];
    
    textViewTitle = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    textViewTitle.text = currentDicoLesson.title;
    [textViewTitle setFont:[UIFont fontWithName:@"Helvetica" size:10]];
    [textViewTitle setTextColor:[UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1]];
    textViewTitle.editable = NO;
    
    [contentView addSubview:textView];
    [contentView addSubview:textViewTitle];
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
    
    double delayInSeconds1 = 0.1;
    dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds1 * NSEC_PER_SEC);
    dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
        [self getHeight];
    });
    
}

-(void)getHeight{
    CGRect frame2;
    frame2 = textView.frame;
    frame2.size.height = [textView contentSize].height + 1000;
    NSLog(@"%f", frame2.size.height);
    textView.frame = frame2;
    contentView.frame = frame2;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    // if the attachment has a hyperlinkURL then this is currently ignored
    DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
    imageView.delegate = self;
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
