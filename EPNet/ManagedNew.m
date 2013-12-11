//
//  ManagedNew.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 17/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//


#import "ManagedNew.h"

@implementation ManagedNew
NSArray *dicoNews;

+(void)loadDataFromWebService{
    [self persistNew];
}

+ (void)persistNew{
    NSURL *url = [NSURL URLWithString:@"http://www.epnet.fr/news.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseNews = [[NSMutableArray alloc]init];
        responseNews = JSON;
        for (int i = 0; i < [responseNews count]; i++) {
            NSMutableArray *dicoNew = [responseNews objectAtIndex:i];
            
            NSNumber *v = [dicoNew valueForKey:@"id"];
            NSString *content = [dicoNew valueForKey:@"content"];
            NSString *created_at = [dicoNew valueForKey:@"created_at"];
            NSString *title = [dicoNew valueForKey:@"title"];
            NSString *updated_at = [dicoNew valueForKey:@"updated_at"];
            
            UIImage *imageThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dicoNew valueForKey:@"image"]valueForKey:@"thumb"] valueForKey:@"url"]]]]];
            NSData *tmpImageThumb  = UIImageJPEGRepresentation(imageThumb , 1.0);
            
            UIImage *imageThumbRect = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dicoNew valueForKey:@"image"]valueForKey:@"thumb_rect"] valueForKey:@"url"]]]]];
            NSData *tmpImageThumbRect = UIImageJPEGRepresentation(imageThumbRect , 1.0);
            
            Member *memberByNew = [ManagedMember returnMember:[dicoNew valueForKey:@"member_id"]];
            
            New *existingEntity = [New findFirstByAttribute:@"idNew" withValue:v];
           
            dicoNews = [New findFirstByAttribute:@"idNew" withValue:v];
            
            if([dicoNews valueForKey:@"updated_at"] != updated_at){
                NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idNew ==[c] %@", [dicoNews valueForKey:@"idNew"]];
                New *updateNew = [New findFirstWithPredicate:predicate inContext:localContext];
                if (updateNew) {
                    updateNew.idNew = v;
                    updateNew.content = content;
                    updateNew.created_at = created_at;
                    updateNew.title = title;
                    updateNew.updated_at = updated_at;
                    updateNew.imageThumb = tmpImageThumb;
                    updateNew.imageThumbRect = tmpImageThumbRect;
                    updateNew.member = memberByNew;
                    [localContext saveToPersistentStoreAndWait];
                }
            }
            
            NSLog(@"%@", existingEntity.title);
            
            if (!existingEntity)
            {
                NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
                New *newNew = [New createInContext:localContext];
                newNew.idNew = v;
                newNew.content = content;
                newNew.created_at = created_at;
                newNew.title = title;
                newNew.updated_at = updated_at;
                newNew.imageThumb = tmpImageThumb;
                newNew.imageThumbRect = tmpImageThumbRect;
                newNew.member = memberByNew;

                [localContext saveToPersistentStoreAndWait];
            }
        }
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"notificationLoadMembersNewsFinished" object:nil]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed Response : %@", JSON);
    }];
    [operation start];
}
@end
