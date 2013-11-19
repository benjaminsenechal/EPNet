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
#import "ManagedNew.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

@interface ManagedMember : NSObject
+(void)loadDataFromWebService;
+(Member *)returnMember:(NSString *)idMember;
@property(strong, nonatomic)NSArray *dico;

@end
