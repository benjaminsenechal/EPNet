//
//  ManagedProject.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 19/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "Project.h"
#import "ManagedMember.h"
@interface ManagedProject : NSObject
+(void)persistProject;
@end
