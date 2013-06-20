//
//  ManagedLesson.h
//  EPNet
//
//  Created by Benjamin SENECHAL on 17/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Lesson.h"
#import "Thematic.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "ManagedMember.h"
#import "ManagedThematic.h"
#import "SundownWrapper.h"

@interface ManagedLesson : NSObject
+(void)loadDataFromWebService;
+(Lesson *)returnLessonModelFromDictionary:(NSMutableArray *)dico withContext:(NSManagedObjectContext *)managedObjectContext;

@end
