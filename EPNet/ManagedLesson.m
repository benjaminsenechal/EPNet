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
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSArray *lessons;
   [self deleteAllLesson:managedObjectContext andArray:lessons];
   [self addLesson:managedObjectContext andArray:lessons];
    NSLog(@"ManagedLesson");
}

+(void)deleteAllLesson:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)lesson
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Lesson" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    lesson = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject * m in lesson) {
        [managedObjectContext deleteObject:m];
    }
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

+(void)addLesson:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)new
{
    NSURL *url = [NSURL URLWithString:@"http://epnet.fr/thematics.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseThematics;
        responseThematics = JSON;
        for (int i = 0; i < [responseThematics count]; i++) {
           NSMutableArray *dicoThematic = [[responseThematics valueForKey:@"lessons"]objectAtIndex:i];

            for (int y = 0; y < [dicoThematic count] ; y++) {
                Lesson *newLesson = [NSEntityDescription insertNewObjectForEntityForName:@"Lesson" inManagedObjectContext:managedObjectContext];
                NSMutableArray *dico = [dicoThematic objectAtIndex:y];
                NSNumber *v = [dico valueForKey:@"idLesson"];
                newLesson.idLesson = v;
                //newLesson.content = [dico valueForKey:@"content"];
                NSString *html = [SundownWrapper convertMarkdownString:[dico valueForKey:@"content"]];
                NSData *HTMLData = [html dataUsingEncoding:NSUTF8StringEncoding];
                newLesson.content = HTMLData;
                
                newLesson.title = [dico valueForKey:@"title" ];
                newLesson.updated_at = [dico valueForKey:@"updated_at"];
                newLesson.created_at = [dico valueForKey:@"created_at"];
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[dico valueForKey:@"image"]valueForKey:@"url"]]]]];
                NSData *tmpImage  = UIImageJPEGRepresentation(image , 1.0);
                newLesson.image = tmpImage;
                
                UIImage *imageThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dico valueForKey:@"image"]valueForKey:@"thumb"] valueForKey:@"url"]]]]];
                NSData *tmpImageThumb  = UIImageJPEGRepresentation(imageThumb , 1.0);
                newLesson.imageThumb = tmpImageThumb;
                
                UIImage *imageThumbRect = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dico valueForKey:@"image"]valueForKey:@"thumb_rect"] valueForKey:@"url"]]]]];
                NSData *tmpImageThumbRect = UIImageJPEGRepresentation(imageThumbRect , 1.0);
                newLesson.imageThumbRect = tmpImageThumbRect;
               
                Member *memberByNew = [ManagedMember returnMemberModelWithId:[dico valueForKey:@"member_id"] withContext:managedObjectContext];
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


+(Lesson *)returnLessonModelFromDictionary:(NSMutableArray *)dicoThematic withContext:(NSManagedObjectContext *)managedObjectContext
{
    Lesson *newLesson = [NSEntityDescription insertNewObjectForEntityForName:@"Lesson" inManagedObjectContext:managedObjectContext];
  //  for (int i = 0; i < [dico count]; i++) {

   //     NSMutableArray *dicoThematic = [dico objectAtIndex:i];
        newLesson.title = [dicoThematic valueForKey:@"title"];

        NSNumber *v = [dicoThematic valueForKey:@"id"];
        newLesson.idLesson = v;
       // newLesson.content = [dicoThematic valueForKey:@"content"];
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

        Member *memberByNew = [ManagedMember returnMemberModelWithId:[dicoThematic valueForKey:@"member_id"] withContext:managedObjectContext];
        newLesson.member = memberByNew;
        
       // NSLog(@"LEsson %@", newLesson.title);
        
    //newLesson.member =

  //  }
    return newLesson;
}
@end
