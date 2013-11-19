//
//  ManagedLesson.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 17/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "ManagedLesson.h"

@implementation ManagedLesson

+(void)loadDataFromWebService{
    [self persistLesson];
}

+(void)persistLesson{
    NSURL *url = [NSURL URLWithString:@"http://epnet.fr/thematics.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseThematics = [[NSMutableArray alloc]init];
        responseThematics = JSON;
        for (int i = 0; i < [responseThematics count]; i++) {
            
            NSMutableArray *dicoThematic = [[responseThematics valueForKey:@"lessons"]objectAtIndex:i];

            for (int y = 0; y < [dicoThematic count]; y++) {
                
                NSMutableArray *dico = [dicoThematic objectAtIndex:y];
                NSNumber *v = [dico valueForKey:@"idLesson"];
                NSString *html = [SundownWrapper convertMarkdownString:[dico valueForKey:@"content"]];
                NSData *HTMLData = [html dataUsingEncoding:NSUTF8StringEncoding];
                
                NSString *title = [dico valueForKey:@"title" ];

                NSString *updated_at = [dico valueForKey:@"updated_at"];
                NSString *created_at = [dico valueForKey:@"created_at"];
                
                UIImage *imageThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dico valueForKey:@"image"]valueForKey:@"thumb"] valueForKey:@"url"]]]]];
                NSData *tmpImageThumb  = UIImageJPEGRepresentation(imageThumb , 1.0);
                
                UIImage *imageThumbRect = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dico valueForKey:@"image"]valueForKey:@"thumb_rect"] valueForKey:@"url"]]]]];
                NSData *tmpImageThumbRect = UIImageJPEGRepresentation(imageThumbRect , 1.0);
                
                Member *memberByNew = [ManagedMember returnMember:[dico valueForKey:@"member_id"]];
                
                Thematic *thematicByLesson = [ManagedThematic returnThematicModelWithId:[dico valueForKey:@"thematic_id"]];
                
                Lesson *existingEntity = [Lesson findFirstByAttribute:@"idLesson" withValue:v];
                
                if (!existingEntity)
                {
                    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
                    Lesson *newLesson = [Lesson createInContext:localContext];
                    newLesson.idLesson = v;
                    newLesson.content = HTMLData;
                    newLesson.title = title;
                    newLesson.updated_at = updated_at;
                    newLesson.created_at = created_at;
                    newLesson.imageThumb = tmpImageThumb;
                    newLesson.imageThumbRect = tmpImageThumbRect;
                    newLesson.thematic = thematicByLesson;
                    newLesson.member = memberByNew;

                    [localContext saveToPersistentStoreAndWait];
                }
            }
            
        }

        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"finishLoadLessonFromWS" object:nil]];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed Response : %@", JSON);
    }];
    [operation start];
}

/*
+(void)addLesson:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)new
{
    NSURL *url = [NSURL URLWithString:@"http://epnet.fr/thematics.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseThematics = [[NSMutableArray alloc]init];
        responseThematics = JSON;
        for (int i = 0; i < [responseThematics count]; i++) {
           NSMutableArray *dicoThematic = [[responseThematics valueForKey:@"lessons"]objectAtIndex:i];

            for (int y = 0; y < [dicoThematic count] ; y++) {
                Lesson *newLesson = [NSEntityDescription insertNewObjectForEntityForName:@"Lesson" inManagedObjectContext:managedObjectContext];
                NSMutableArray *dico = [dicoThematic objectAtIndex:y];
                NSNumber *v = [dico valueForKey:@"idLesson"];
                newLesson.idLesson = v;
                
                NSString *html = [SundownWrapper convertMarkdownString:[dico valueForKey:@"content"]];
                NSData *HTMLData = [html dataUsingEncoding:NSUTF8StringEncoding];
                newLesson.content = HTMLData;
                
                newLesson.title = [dico valueForKey:@"title" ];
                newLesson.updated_at = [dico valueForKey:@"updated_at"];
                newLesson.created_at = [dico valueForKey:@"created_at"];
                
                UIImage *imageThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dico valueForKey:@"image"]valueForKey:@"thumb"] valueForKey:@"url"]]]]];
                NSData *tmpImageThumb  = UIImageJPEGRepresentation(imageThumb , 1.0);
                newLesson.imageThumb = tmpImageThumb;
                
                UIImage *imageThumbRect = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dico valueForKey:@"image"]valueForKey:@"thumb_rect"] valueForKey:@"url"]]]]];
                NSData *tmpImageThumbRect = UIImageJPEGRepresentation(imageThumbRect , 1.0);
                newLesson.imageThumbRect = tmpImageThumbRect;
               
                Member *memberByNew = [ManagedMember returnMember:[dico valueForKey:@"member_id"]];
                newLesson.member = memberByNew;

                Thematic *thematicByLesson = [ManagedThematic returnThematicModelWithId:[dico valueForKey:@"thematic_id"] withContext:managedObjectContext];
                newLesson.thematic = thematicByLesson;

            }
        }

        NSError *error;
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
                
        [[NSNotificationCenter defaultCenter]postNotification:[NSNotification notificationWithName:@"finishLoadFromWS" object:nil]];
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed Response : %@", JSON);
    }];
    [operation start];
    
}
*/
+(Lesson *)returnLessonModelFromDictionary:(NSMutableArray *)dicoThematic
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    Lesson *newLesson = [Lesson createInContext:localContext];

    newLesson.title = [dicoThematic valueForKey:@"title"];
    
    NSNumber *v = [dicoThematic valueForKey:@"id"];
    newLesson.idLesson = v;
    NSString *html = [SundownWrapper convertMarkdownString:[dicoThematic valueForKey:@"content"]];
    NSData *HTMLData = [html dataUsingEncoding:NSUTF8StringEncoding];
    newLesson.content = HTMLData;
    newLesson.title = [dicoThematic valueForKey:@"title"];
    newLesson.updated_at = [dicoThematic valueForKey:@"updated_at"];
    newLesson.created_at = [dicoThematic valueForKey:@"created_at"];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[dicoThematic valueForKey:@"image"]valueForKey:@"url"]]]]];
    NSData *tmpImage  = UIImageJPEGRepresentation(image , 1.0);
    newLesson.image = tmpImage;
    
    UIImage *imageThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dicoThematic valueForKey:@"image"]valueForKey:@"thumb"] valueForKey:@"url"]]]]];
    NSData *tmpImageThumb  = UIImageJPEGRepresentation(imageThumb , 1.0);
    newLesson.imageThumb = tmpImageThumb;
    
    UIImage *imageThumbRect = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dicoThematic valueForKey:@"image"]valueForKey:@"thumb_rect"] valueForKey:@"url"]]]]];
    NSData *tmpImageThumbRect = UIImageJPEGRepresentation(imageThumbRect , 1.0);
    newLesson.imageThumbRect = tmpImageThumbRect;
    
    Member *memberByNew = [ManagedMember returnMember:[dicoThematic valueForKey:@"member_id"]];
    newLesson.member = memberByNew;

  //  [localContext saveToPersistentStoreAndWait];

    return newLesson;
}
/*
+(Lesson *)returnLessonModelFromDictionary:(NSMutableArray *)dicoThematic withContext:(NSManagedObjectContext *)managedObjectContext
{
        Lesson *newLesson = [NSEntityDescription insertNewObjectForEntityForName:@"Lesson" inManagedObjectContext:managedObjectContext];

        newLesson.title = [dicoThematic valueForKey:@"title"];

        NSNumber *v = [dicoThematic valueForKey:@"id"];
        newLesson.idLesson = v;
        NSString *html = [SundownWrapper convertMarkdownString:[dicoThematic valueForKey:@"content"]];
        NSData *HTMLData = [html dataUsingEncoding:NSUTF8StringEncoding];
        newLesson.content = HTMLData;
        newLesson.title = [dicoThematic valueForKey:@"title"];
        newLesson.updated_at = [dicoThematic valueForKey:@"updated_at"];
        newLesson.created_at = [dicoThematic valueForKey:@"created_at"];
        
         UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[dicoThematic valueForKey:@"image"]valueForKey:@"url"]]]]];
        NSData *tmpImage  = UIImageJPEGRepresentation(image , 1.0);
        newLesson.image = tmpImage;
        
        UIImage *imageThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dicoThematic valueForKey:@"image"]valueForKey:@"thumb"] valueForKey:@"url"]]]]];
        NSData *tmpImageThumb  = UIImageJPEGRepresentation(imageThumb , 1.0);
        newLesson.imageThumb = tmpImageThumb;
        
        UIImage *imageThumbRect = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dicoThematic valueForKey:@"image"]valueForKey:@"thumb_rect"] valueForKey:@"url"]]]]];
        NSData *tmpImageThumbRect = UIImageJPEGRepresentation(imageThumbRect , 1.0);
        newLesson.imageThumbRect = tmpImageThumbRect;

        Member *memberByNew = [ManagedMember returnMember:[dicoThematic valueForKey:@"member_id"]];
        newLesson.member = memberByNew;

    return newLesson;
}*/
@end
