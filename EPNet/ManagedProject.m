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
    [self persistProject];
}

+(void)persistProject{
    NSURL *url = [NSURL URLWithString:@"http://epnet.fr/projects.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseProject = [[NSMutableArray alloc]init];
        responseProject = JSON;
        for (int i = 0; i < [responseProject count]; i++) {
            NSDictionary *dicoNew = [responseProject objectAtIndex:i];
            
            
            NSNumber *v = [dicoNew valueForKey:@"id"];

            NSString *desc = [dicoNew valueForKey:@"description"];
            NSString *created_at = [dicoNew valueForKey:@"created_at"];
            NSString *title = [dicoNew valueForKey:@"title"];
            NSString *updated_at = [dicoNew valueForKey:@"updated_at"];
            UIImage *imageThumbRect = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dicoNew valueForKey:@"image"]valueForKey:@"thumb_rect"] valueForKey:@"url"]]]]];
            NSData *tmpImageThumbRect = UIImageJPEGRepresentation(imageThumbRect , 1.0);
            
            NSSet *m = [dicoNew valueForKey:@"members"];
            NSMutableSet *tagNamesArray = [[NSMutableSet alloc] initWithCapacity:m.count];
            
            for (int y=0; y < [[dicoNew valueForKey:@"members"]count ]; y++ ){
                Member *memberByNew=[ManagedMember returnMember:[[[dicoNew valueForKey:@"members"]valueForKey:@"id"] objectAtIndex:y]];
                [tagNamesArray addObject:memberByNew];
            }
            
            Project *existingEntity = [Project findFirstByAttribute:@"idProject" withValue:v];
            
            if (!existingEntity)
            {
                NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
                Project *newProject = [Project createInContext:localContext];
                newProject.idProject = v;
                newProject.desc = desc;
                newProject.created_at = created_at;
                newProject.title = title;
                newProject.updated_at = updated_at;
                newProject.imageThumbRect = tmpImageThumbRect;
                newProject.member = tagNamesArray;
                [localContext saveToPersistentStoreAndWait];
            }
        }
        
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"notificationLoadProjectFinished" object:nil]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed Response : %@", JSON);
    }];
    [operation start];

}

@end
