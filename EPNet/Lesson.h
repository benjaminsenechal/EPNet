//
//  Lesson.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 18/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Member, Thematic;

@interface Lesson : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSNumber * idLesson;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSData * imageThumb;
@property (nonatomic, retain) NSData * imageThumbRect;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) Member *member;
@property (nonatomic, retain) Thematic *thematic;

@end
