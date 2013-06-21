//
//  CustomEquipeCell.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomEquipeCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageMember;
@property (strong, nonatomic) IBOutlet UILabel *labelLast;
@property (strong, nonatomic) IBOutlet UILabel *labelFirst;
@property (strong, nonatomic) IBOutlet UILabel *labelRole;
@property (strong, nonatomic) IBOutlet UIView *viewCustom;
@property (strong, nonatomic) IBOutlet UILabel *label;

@end
