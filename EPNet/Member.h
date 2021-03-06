//
//  Member.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 26/10/2013.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class New;

@interface Member : NSManagedObject

@property (nonatomic, retain) NSData * avatar;
@property (nonatomic, retain) NSData * avatarThumb;
@property (nonatomic, retain) NSNumber * client;
@property (nonatomic, retain) NSString * created_at;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * facebook;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * github;
@property (nonatomic, retain) NSNumber * idMember;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * linkedin;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * updated_at;
@property (nonatomic, retain) NSString * viadeo;
@property (nonatomic, retain) New *news;
@end

@interface Member (CoreDataGeneratedAccessors)

- (void)insertObject:(New *)value inNewsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromNewsAtIndex:(NSUInteger)idx;
- (void)insertNews:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeNewsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInNewsAtIndex:(NSUInteger)idx withObject:(New *)value;
- (void)replaceNewsAtIndexes:(NSIndexSet *)indexes withNews:(NSArray *)values;
- (void)addNewsObject:(New *)value;
- (void)removeNewsObject:(New *)value;
@end
