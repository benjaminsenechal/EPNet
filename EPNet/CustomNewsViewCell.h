//
//  CustomNewsViewCell.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 20/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomNewsViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleNews;
@property (strong, nonatomic) IBOutlet UILabel *dateNews;
@property (strong, nonatomic) IBOutlet UIImageView *newsImage;

@end
