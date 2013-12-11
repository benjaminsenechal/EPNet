//
//  New.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 26/10/2013.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Member;

@interface New : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * idNew;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSData * imageThumb;
@property (nonatomic, retain) NSData * imageThumbRect;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) Member *member;

@end
