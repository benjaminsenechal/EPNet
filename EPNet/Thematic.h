//
//  Thematic.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 18/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Lesson;

@interface Thematic : NSManagedObject

@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * idThematic;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) Lesson *lesson;

@end
