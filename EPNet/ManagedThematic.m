//
//  ManagedThematic.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 17/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "ManagedThematic.h"

@implementation ManagedThematic

+(void)loadDataFromWebService{
    [self persistThematic];
}

+(void)persistThematic{
    NSURL *url = [NSURL URLWithString:@"http://epnet.fr/thematics.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseThematics;
        responseThematics = JSON;
        for (int i = 0; i < [responseThematics count]; i++) {
            NSDictionary *dicoThematic = [responseThematics objectAtIndex:i];
            
            NSNumber *v = [dicoThematic objectForKey:@"id"];
            NSString *title = [dicoThematic objectForKey:@"title"];
            NSString *updated_at = [dicoThematic objectForKey:@"updated_at"];
            NSString *created_at = [dicoThematic objectForKey:@"created_at"];
            
            NSSet *m = [dicoThematic objectForKey:@"lessons"];
            NSMutableSet *lessonsArray = [[NSMutableSet alloc] initWithCapacity:m.count];
            
            for (int y=0; y < [[dicoThematic valueForKey:@"lessons"]count]; y++ ){
                Lesson *lessonByThem = [ManagedLesson returnLessonModelFromDictionary:[[dicoThematic objectForKey:@"lessons"] objectAtIndex:y]];
                [lessonsArray addObject:lessonByThem];
            }

            Thematic *existingEntity = [Thematic findFirstByAttribute:@"idThematic" withValue:v];

            if (!existingEntity)
            {
                NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
                Thematic *newThematic = [Thematic createInContext:localContext];
                newThematic.idThematic = v;
                newThematic.title = title;
                newThematic.updated_at = updated_at;
                newThematic.created_at = created_at;
                newThematic.lesson = lessonsArray;
                [localContext saveToPersistentStoreAndWait];
            }
            
        }
        
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"finishLoadThematicFromWS" object:nil]];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed Response : %@", JSON);
    }];
    [operation start];
    

}

+(Thematic *)returnThematicModelWithId:(NSString *)myid
{
    Thematic *personFounded;
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idThematic ==[c] %@", myid];
    personFounded = [Thematic findFirstWithPredicate:predicate inContext:localContext];
    if (personFounded) {
        return personFounded;
    }
    return personFounded;
    
}

@end
