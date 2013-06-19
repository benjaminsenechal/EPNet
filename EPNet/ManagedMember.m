//
//  ManagedMember.m
//  EPNet
//
//  Created by Benjamin SENECHAL on 15/06/13.
//  Copyright (c) 2013 Benjamin SENECHAL. All rights reserved.
//

#import "ManagedMember.h"
#import "Member.h"
@implementation ManagedMember
+(Member *)returnMemberModelFromDictionary:(NSDictionary *)dicoNew withContext:(NSManagedObjectContext *)managedObjectContext
{
    Member *newMember = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Member"
                         inManagedObjectContext:managedObjectContext];
    NSNumber *v = [dicoNew valueForKey:@"id"];
    newMember.idMember = v;
    
    UIImage *avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dicoNew valueForKey:@"avatar"] valueForKey:@"url"] ]]]];
    NSData *imageData = UIImagePNGRepresentation(avatar);
    [newMember.avatar setValue:imageData forKey:@"avatar"];
    
    UIImage *avatarThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[dicoNew valueForKey:@"avatar"] valueForKey:@"thumb"] valueForKey:@"url"]]]]];
    NSData *tmpAvatarThumb  = UIImageJPEGRepresentation(avatarThumb , 1.0);
    newMember.avatarThumb = tmpAvatarThumb;
    
    NSNumber *va = [dicoNew valueForKey:@"client"];
    newMember.client = va;
    newMember.updated_at = [dicoNew valueForKey:@"updated_at"];
    newMember.created_at = [dicoNew valueForKey:@"created_at"];
    newMember.firstname = [dicoNew valueForKey:@"firstname"];
    newMember.lastname = [dicoNew valueForKey:@"lastname"];
    newMember.role = [dicoNew valueForKey:@"role"];
    newMember.login = [dicoNew valueForKey:@"login"];
    
    if([dicoNew valueForKey:@"facebook"] == [NSNull null] ||
       [dicoNew valueForKey:@"description"] == [NSNull null] ||
       [dicoNew valueForKey:@"email"] == [NSNull null] ||
       [dicoNew valueForKey:@"github"] == [NSNull null] ||
       [dicoNew valueForKey:@"linkedin"] == [NSNull null] ||
       [dicoNew valueForKey:@"twitter"] == [NSNull null] ||
       [dicoNew valueForKey:@"viadeo"] == [NSNull null]){
        newMember.facebook = @"null";
        newMember.desc = @"null";
        newMember.email = @"null";
        newMember.github = @"null";
        newMember.linkedin = @"null";
        newMember.twitter = @"null";
        newMember.viadeo = @"null";
    }else{
        newMember.facebook = [dicoNew valueForKey:@"facebook"];
        newMember.desc = [dicoNew valueForKey:@"description"];
        newMember.email = [dicoNew valueForKey:@"email"];
        newMember.github = [dicoNew valueForKey:@"github"];
        newMember.linkedin = [dicoNew valueForKey:@"linkedin"];
        newMember.twitter = [dicoNew valueForKey:@"twitter"];
        newMember.viadeo = [dicoNew valueForKey:@"viadeo"];
        
    }
    return newMember;
}

+(Member *)returnMemberModelWithId:(NSString *)myid withContext:(NSManagedObjectContext *)managedObjectContext
{
    NSArray *m;
    Member *myMember;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Member" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    m = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (int i = 0; i < [m count]; i++) {
        myMember = [m objectAtIndex:i];
        if([myMember.idMember isEqual:myid]){
            return myMember;
        }
    }
    
    return  myMember;

}

+(void)loadDataFromWebService{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    NSArray *members = [[NSArray alloc] init];
    NSLog(@"ManagedMember");

    [self deleteAllMember:managedObjectContext andArray:members];
    [self addMember:managedObjectContext andArray:members];

}

+(void)deleteAllMember:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)members
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Member" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    members = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject * m in members) {
        [managedObjectContext deleteObject:m];
    }
    
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

+(void)addMember:(NSManagedObjectContext *)managedObjectContext andArray:(NSArray *)members
{
    NSURL *url = [NSURL URLWithString:@"http://www.epnet.fr/members.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseMembers = [[NSMutableArray alloc]init];
        responseMembers = JSON;
        for (int i = 0; i < [responseMembers count]; i++) {
            NSDictionary *dicoNew = [responseMembers objectAtIndex:i];
            
            Member *newMember = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"Member"
                                   inManagedObjectContext:managedObjectContext];
           NSNumber *v = [dicoNew objectForKey:@"id"];
            newMember.idMember = v;
            
          /*  UIImage *avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dicoNew valueForKey:@"avatar"] valueForKey:@"url"] ]]]];
            NSData *tmpAvatar = UIImageJPEGRepresentation(avatar, 1.0);
            newMember.avatar = tmpAvatar;          
            NSLog(@"%@", [[dicoNew valueForKey:@"avatar"] valueForKey:@"url"]);
            */
            UIImage *avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[dicoNew objectForKey:@"avatar"] objectForKey:@"url"] ]]]];
            NSData *imageData = UIImagePNGRepresentation(avatar);
            [newMember.avatar setValue:imageData forKey:@"avatar"];
            
            UIImage *avatarThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[[dicoNew objectForKey:@"avatar"] objectForKey:@"thumb"] objectForKey:@"url"]]]]];
            NSData *tmpAvatarThumb  = UIImageJPEGRepresentation(avatarThumb , 1.0);
            newMember.avatarThumb = tmpAvatarThumb;
            
            NSNumber *va = [dicoNew objectForKey:@"client"];
            newMember.client = va;
            newMember.updated_at = [dicoNew objectForKey:@"updated_at"];
            newMember.created_at = [dicoNew objectForKey:@"created_at"];
            newMember.firstname = [dicoNew objectForKey:@"firstname"];
            newMember.lastname = [dicoNew objectForKey:@"lastname"];
            newMember.role = [dicoNew objectForKey:@"role"];
            newMember.login = [dicoNew objectForKey:@"login"];
         
            if([dicoNew objectForKey:@"facebook"] == [NSNull null] ||
               [dicoNew objectForKey:@"description"] == [NSNull null] ||
               [dicoNew objectForKey:@"email"] == [NSNull null] ||
               [dicoNew objectForKey:@"github"] == [NSNull null] ||
               [dicoNew objectForKey:@"linkedin"] == [NSNull null] ||
               [dicoNew objectForKey:@"twitter"] == [NSNull null] ||
               [dicoNew objectForKey:@"viadeo"] == [NSNull null]){
                newMember.facebook = @"null";
                newMember.desc = @"null";
                newMember.email = @"null";
                newMember.github = @"null";
                newMember.linkedin = @"null";
                newMember.twitter = @"null";
                newMember.viadeo = @"null";
            }else{
                newMember.facebook = [dicoNew objectForKey:@"facebook"];
                newMember.desc = [dicoNew objectForKey:@"description"];
                newMember.email = [dicoNew objectForKey:@"email"];
                newMember.github = [dicoNew objectForKey:@"github"];
                newMember.linkedin = [dicoNew objectForKey:@"linkedin"];
                newMember.twitter = [dicoNew objectForKey:@"twitter"];
                newMember.viadeo = [dicoNew objectForKey:@"viadeo"];

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
@end
