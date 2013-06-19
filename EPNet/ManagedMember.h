//
//  ManagedMember.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 15/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Member.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface ManagedMember : NSObject
+(void)loadDataFromWebService;
+(Member *)returnMemberModelFromDictionary:(NSDictionary *)dicoNew withContext:(NSManagedObjectContext *)managedObjectContext;
+(Member *)returnMemberModelWithId:(NSString *)myid withContext:(NSManagedObjectContext *)managedObjectContext;

@end
