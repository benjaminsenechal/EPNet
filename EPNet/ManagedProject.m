//
//  ManagedProject.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 19/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "ManagedProject.h"

@implementation ManagedProject

+(void)loadDataFromWebService{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSArray *projects = [[NSArray alloc] init];
    [self deleteAllProject:managedObjectContext andArray:projects];
    [self addProject:managedObjectContext andArray:projects];
    NSLog(@"ManagedProject");
}

+(void)deleteAllProject:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)project
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Project" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    project = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject * m in project) {
        [managedObjectContext deleteObject:m];
    }
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

+(void)addProject:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)new
{
    NSURL *url = [NSURL URLWithString:@"http://epnet.fr/projects.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseProject = [[NSMutableArray alloc]init];
        responseProject = JSON;
        for (int i = 0; i < [responseProject count]; i++) {
            NSDictionary *dicoNew = [responseProject objectAtIndex:i];
            Project *newProject = [NSEntityDescription
                           insertNewObjectForEntityForName:@"Project"
                           inManagedObjectContext:managedObjectContext];
            NSNumber *v = [dicoNew valueForKey:@"id"];
            newProject.idProject = v;
            newProject.desc = [dicoNew valueForKey:@"description"];
            newProject.created_at = [dicoNew valueForKey:@"created_at"];
            newProject.title = [dicoNew valueForKey:@"title"];
            newProject.updated_at = [dicoNew valueForKey:@"updated_at"];
            
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[dicoNew valueForKey:@"image"]valueForKey:@"url"]]]]];
            NSData *tmpImage  = UIImageJPEGRepresentation(image , 1.0);
            newProject.image = tmpImage;
            
            UIImage *imageThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dicoNew valueForKey:@"image"]valueForKey:@"thumb"] valueForKey:@"url"]]]]];
            NSData *tmpImageThumb  = UIImageJPEGRepresentation(imageThumb , 1.0);
            newProject.imageThumb = tmpImageThumb;
            
            UIImage *imageThumbRect = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dicoNew valueForKey:@"image"]valueForKey:@"thumb_rect"] valueForKey:@"url"]]]]];
            NSData *tmpImageThumbRect = UIImageJPEGRepresentation(imageThumbRect , 1.0);
            newProject.imageThumbRect = tmpImageThumbRect;
       
            NSSet *m = newProject.member;
            NSMutableSet *tagNamesArray = [[NSMutableSet alloc] initWithCapacity:m.count];
            
            for (int y=0; y < [[dicoNew valueForKey:@"members"]count ]; y++ ){
                //Member *memberByNew=[ManagedMember returnMemberModelFromDictionary:[[dicoNew valueForKey:@"members"]objectAtIndex:y] withContext:managedObjectContext];
               // newProject.member = memberByNew;
                Member *memberByNew=[ManagedMember returnMemberModelFromDictionary:[[dicoNew valueForKey:@"members"]objectAtIndex:y] withContext:managedObjectContext];
               [tagNamesArray addObject:memberByNew];
            }
            newProject.member = tagNamesArray;
            
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


@end
