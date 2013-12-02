//
//  AProposViewController.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "AProposViewController.h"

@interface AProposViewController ()
@property (nonatomic, assign) CGFloat peekLeftAmount;

@end

@implementation AProposViewController
@synthesize aProposBtn;
@synthesize peekLeftAmount;
@synthesize logo;
@synthesize labelSite;
@synthesize labelContact;
@synthesize textDescription;
@synthesize textAdress;
@synthesize imageMap;
@synthesize labelTelNumber;
@synthesize labelSuivezNous;
@synthesize labelTwitter;
@synthesize scroll;
@synthesize labelGithub;
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.peekLeftAmount = 40.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    
    // Set Image
    logo = [[UIImageView alloc] initWithFrame:CGRectMake(0, -200, 280, 280)];
    [logo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"logoA.png"]]];
    
    // Set text
    textDescription = [[UITextView alloc] initWithFrame:CGRectMake(10, 110, 250, 500)];
    textDescription.text = @"EPNet est une association de l'EPSI, basée sur la technologie web. Créée en Septembre 2012, les principaux buts de l’association sont de vous faire avancer sur vos projets à l’aide de formations et de réunions hebdomadaires sur l’état de vos compétences, mais aussi de vous mettre en contact avec des professionnels.\n\nLa technologie web est omniprésente de nos jours et permet des interactions de plus en plus innovantes et dynamiques. Grâce à sa caractéristique multiplateforme, le web est accessible à tous et pour tous.\n\nLes principaux sujets de motivations de l’association sont ceux liés à votre évolution professionnelle. En effet, plus elle sera ascendante, plus vos projets prendront de l’ampleur et cela permettra de vous forger une image importante aux yeux de vos futures entreprises.";
    textDescription.font = FONT(14);
    textDescription.backgroundColor = [UIColor clearColor];
    textDescription.textAlignment = NSTextAlignmentNatural;
    [textDescription setUserInteractionEnabled:NO];
    
    // Web site link
    labelSite = [[UILabel alloc] initWithFrame:CGRectMake(0, 520, 280, 30)];
    labelSite.highlightedTextColor=[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1];
    labelSite.text = @"epnet.fr";
    labelSite.font = FONT(14);
    [labelSite setTextColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1]];
    labelSite.backgroundColor = [UIColor clearColor];
    labelSite.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lienEPnet:)];
    [labelSite setUserInteractionEnabled:YES];
    [labelSite addGestureRecognizer:tap];

    // Title contact
    /*labelContact = [[UILabel alloc] initWithFrame:CGRectMake(0, 550, 280, 30)];
    labelContact.textAlignment = NSTextAlignmentCenter;
    labelContact.text = @"Entrons en contact.";
    labelContact.font = FONT(24);
    [labelContact setFont:[UIFont systemFontOfSize:24]];
    [labelContact setTextColor:[UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1]];
    labelContact.backgroundColor = [UIColor clearColor];
    
    
    textAdress = [[UITextView alloc] initWithFrame:CGRectMake(0, 580, 280, 70)];
    textAdress.text = @"EPNet\n23 rue du Dépôt\n62000, Arras";
    textAdress.font = FONT(14);
    [textAdress setTextColor:[UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1]];
    textAdress.backgroundColor = [UIColor clearColor];
    [textAdress setUserInteractionEnabled:NO];
    */
    // Number
    labelTelNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, 540, 280, 30)];
    labelTelNumber.text = @"06 34 25 45 34";
    labelTelNumber.font = FONT(14);
    labelTelNumber.textAlignment = NSTextAlignmentCenter;
    [labelTelNumber setTextColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1]];
    labelTelNumber.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer* call = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call:)];
    [labelTelNumber setUserInteractionEnabled:YES];
    [labelTelNumber addGestureRecognizer:call];
    
    // Set Image
    imageMap = [[UIImageView alloc] initWithFrame:CGRectMake(0, 570, 280, 149)];
    [imageMap setImage:[UIImage imageNamed:[NSString stringWithFormat:@"gmap.png"]]];
    
    /*
    labelSuivezNous = [[UILabel alloc] initWithFrame:CGRectMake(0, 740, 280, 30)];
    labelSuivezNous.text = @"Suivez Nous.";
    labelSuivezNous.textAlignment = NSTextAlignmentCenter;
    labelSuivezNous.font = FONT(24);
    [labelSuivezNous setTextColor:[UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1]];
    labelSuivezNous.backgroundColor = [UIColor clearColor];*/
    
    // Twitter
    labelTwitter = [[UILabel alloc] initWithFrame:CGRectMake(0, 915, 280, 30)];
    labelTwitter.text = @"Twitter";
    labelTwitter.font = FONT(14);
    [labelTwitter setTextColor:[UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1]];
    labelTwitter.backgroundColor = [UIColor clearColor];
    
    // Add elements to uiscrollview
    [scroll setScrollEnabled:YES];
    [scroll setContentSize:CGSizeMake(200, 1000)];
    [scroll addSubview:logo];
    [scroll addSubview:textDescription];
    [scroll addSubview:labelSite];
    [scroll addSubview:labelContact];
    [scroll addSubview:textAdress];
    [scroll addSubview:labelTelNumber];
    [scroll addSubview:imageMap];
    [scroll addSubview:labelSuivezNous];
    [scroll addSubview:labelTwitter];
    
}
-(IBAction)lienEPnet:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.epnet.fr"]];
}
-(IBAction)call:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://0634254534"]];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
