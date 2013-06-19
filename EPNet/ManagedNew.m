//
//  ManagedNew.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 17/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//


#import "ManagedNew.h"

@implementation ManagedNew

+(void)loadDataFromWebService{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSArray *news;
    [self deleteAllNews:managedObjectContext andArray:news];
    [self addNew:managedObjectContext andArray:news];
    NSLog(@"ManagedNew");
}

+(void)deleteAllNews:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)new
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"New" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    new = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject * m in new) {
        [managedObjectContext deleteObject:m];
    }
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

+(void)addNew:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)new
{
    NSURL *url = [NSURL URLWithString:@"http://www.epnet.fr/news.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseNews;
        responseNews = JSON;
        for (int i = 0; i < [responseNews count]; i++) {
            NSMutableArray *dicoNew = [responseNews objectAtIndex:i];
            New *newNew = [NSEntityDescription
                                 insertNewObjectForEntityForName:@"New"
                                 inManagedObjectContext:managedObjectContext];
            NSNumber *v = [dicoNew valueForKey:@"id"];
            newNew.idNew = v;
            newNew.content = [dicoNew valueForKey:@"content"];
            newNew.created_at = [dicoNew valueForKey:@"created_at"];
            newNew.title = [dicoNew valueForKey:@"title"];
            newNew.updated_at = [dicoNew valueForKey:@"updated_at"];
           
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dicoNew valueForKey:@"image"]valueForKey:@"url"]]]]];
            NSData *tmpImage  = UIImageJPEGRepresentation(image , 1.0);
            newNew.image = tmpImage;
            
            UIImage *imageThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[dicoNew valueForKey:@"image"]valueForKey:@"thumb"] valueForKey:@"url"]]]]];
            NSData *tmpImageThumb  = UIImageJPEGRepresentation(imageThumb , 1.0);
            newNew.imageThumb = tmpImageThumb;
            
            UIImage *imageThumbRect = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[dicoNew valueForKey:@"image"]valueForKey:@"thumb_rect"] valueForKey:@"url"]]]]];
            NSData *tmpImageThumbRect = UIImageJPEGRepresentation(imageThumbRect , 1.0);
            newNew.imageThumbRect = tmpImageThumbRect;
            
           Member *memberByNew = [ManagedMember returnMemberModelFromDictionary:[dicoNew valueForKey:@"member"] withContext:managedObjectContext];
           newNew.member = memberByNew;

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
