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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSArray *thematics;
    [self deleteAllThematic:managedObjectContext andArray:thematics];
    [self addThematic:managedObjectContext andArray:thematics];
    NSLog(@"ManagedThematic");
}

+(void)deleteAllThematic:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)thematic
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Thematic" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    thematic = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject * m in thematic) {
        [managedObjectContext deleteObject:m];
    }
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

+(void)addThematic:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)new
{
    NSURL *url = [NSURL URLWithString:@"http://epnet.fr/thematics.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseThematics;
        responseThematics = JSON;
        for (int i = 0; i < [responseThematics count]; i++) {
            NSDictionary *dicoThematic = [responseThematics objectAtIndex:i];
            Thematic *newThematic = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Thematic"
                           inManagedObjectContext:managedObjectContext];
            NSNumber *v = [dicoThematic objectForKey:@"id"];
            newThematic.idThematic = v;
            newThematic.title = [dicoThematic objectForKey:@"title"];
            newThematic.updated_at = [dicoThematic objectForKey:@"updated_at"];
            newThematic.created_at = [dicoThematic objectForKey:@"created_at"];
            /*
            for (int y=0; y < [[dicoThematic objectForKey:@"lessons"]count ]; y++ ){
              Lesson *l = [ManagedLesson returnLessonModelFromDictionary:[[dicoThematic objectForKey:@"lessons"] objectAtIndex:y ]withContext:managedObjectContext];
              newThematic.lesson = l;
            }*/
            NSSet *m = newThematic.lesson;
            NSMutableSet *lessonsArray = [[NSMutableSet alloc] initWithCapacity:m.count];
            
            for (int y=0; y < [[dicoThematic valueForKey:@"lessons"]count ]; y++ ){
                Lesson *lessonByThem=[ManagedLesson returnLessonModelFromDictionary:[[dicoThematic objectForKey:@"lessons"] objectAtIndex:y ]withContext:managedObjectContext];
                [lessonsArray addObject:lessonByThem];
            }
            newThematic.lesson = lessonsArray;
        }
        
        NSError *error;
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        //     [self displayPartenaire:managedObjectContext andArray:members];
        
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"finishLoadFromWS" object:nil]];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed Response : %@", JSON);
    }];
    [operation start];
    
}
+(Thematic *)returnThematicModelWithId:(NSString *)myid withContext:(NSManagedObjectContext *)managedObjectContext
{
    NSArray *m;
    Thematic *myThem;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Thematic" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    m = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i = 0; i < [m count]; i++) {
        myThem = [m objectAtIndex:i];
        if([myThem.idThematic isEqual:myid]){
            return myThem;
        }
    }
    
    return  myThem;
    
}
+(Thematic *)returnThematicModelFromDictionary:(NSDictionary *)dico withContext:(NSManagedObjectContext *)managedObjectContext{
    Thematic *newThematic = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Thematic"
                             inManagedObjectContext:managedObjectContext];
    NSNumber *v = [dico valueForKey:@"id"];
    newThematic.idThematic = v;
    newThematic.title = [dico valueForKey:@"title"];
    newThematic.updated_at = [dico valueForKey:@"updated_at"];
    newThematic.created_at = [dico valueForKey:@"created_at"];
    NSSet *m = newThematic.lesson;
    NSMutableSet *lessonsArray = [[NSMutableSet alloc] initWithCapacity:m.count];
    Lesson *l = [ManagedLesson returnLessonModelFromDictionary:[dico valueForKey:@"lessons"] withContext:managedObjectContext];
    [lessonsArray addObject:l];
    newThematic.lesson = lessonsArray;
    return newThematic;
}

@end
