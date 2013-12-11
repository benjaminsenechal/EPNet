//
//  ManagedThematic.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 17/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Thematic.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "ManagedLesson.h"

@interface ManagedThematic : NSObject
+(void)loadDataFromWebService;
+(Thematic *)returnThematicModelWithId:(NSString *)myid;
@end
