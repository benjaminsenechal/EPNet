//
//  Project.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 19/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Member;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * idProject;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSData * imageThumb;
@property (nonatomic, retain) NSData * imageThumbRect;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSNumber * percent;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSSet *member;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addMemberObject:(Member *)value;
- (void)removeMemberObject:(Member *)value;
- (void)addMember:(NSSet *)values;
- (void)removeMember:(NSSet *)values;

@end
