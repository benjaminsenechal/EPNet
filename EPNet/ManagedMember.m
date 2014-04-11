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
NSArray *dicoMember;

+(void)persistMember{
    NSURL *url = [NSURL URLWithString:@"http://www.epnet.fr/members.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *responseMembers = [[NSMutableArray alloc]init];
        responseMembers = JSON;
        for (int i = 0; i < [responseMembers count]; i++) {
            NSMutableArray *dicoNew = [responseMembers objectAtIndex:i];

            NSNumber *v = [dicoNew valueForKey:@"id"];
            UIImage *avatarThumb = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://epnet.fr/%@",[[[dicoNew valueForKey:@"avatar"] objectForKey:@"thumb"] objectForKey:@"url"]]]]];
            NSData *tmpAvatarThumb  = UIImageJPEGRepresentation(avatarThumb, 1.0);
            NSNumber *va = [dicoNew valueForKey:@"client"];
            NSString *updated_at = [dicoNew valueForKey:@"updated_at"];
            NSString *created_at = [dicoNew valueForKey:@"created_at"];
            NSString *firstname = [dicoNew valueForKey:@"firstname"];
            NSString *lastname = [dicoNew valueForKey:@"lastname"];
            NSString *role = [dicoNew valueForKey:@"role"];
            NSString *login = [dicoNew valueForKey:@"login"];
            NSString *facebook;
            NSString *desc ;
            NSString *email;
            NSString *github;
            NSString *linkedin;
            NSString *twitter;
            NSString *viadeo;
            
            if([dicoNew valueForKey:@"facebook"] == [NSNull null] ||
               [dicoNew valueForKey:@"description"] == [NSNull null] ||
               [dicoNew valueForKey:@"email"] == [NSNull null] ||
               [dicoNew valueForKey:@"github"] == [NSNull null] ||
               [dicoNew valueForKey:@"linkedin"] == [NSNull null] ||
               [dicoNew valueForKey:@"twitter"] == [NSNull null] ||
               [dicoNew valueForKey:@"viadeo"] == [NSNull null]){
                facebook = @"null";
                desc = @"null";
                email = @"null";
                github = @"null";
                linkedin = @"null";
                twitter = @"null";
                viadeo =@"null";
            }else{
                facebook = [dicoNew valueForKey:@"facebook"];
                desc = [dicoNew valueForKey:@"description"];
                email = [dicoNew valueForKey:@"email"];
                github = [dicoNew valueForKey:@"github"];
                linkedin = [dicoNew valueForKey:@"linkedin"];
                twitter = [dicoNew valueForKey:@"twitter"];
                viadeo = [dicoNew valueForKey:@"viadeo"];
            }
            
            NSLog(@"%@",[Member findFirstByAttribute:@"idMember" withValue:v]);
           // dicoMember = [Member findFirstByAttribute:@"idMember" withValue:v];
            
            if([dicoMember valueForKey:@"updated_at"] != updated_at){
                NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idMember ==[c] %@", [dicoMember valueForKey:@"idMember"]];
                Member *updateMember = [Member findFirstWithPredicate:predicate inContext:localContext];
                if (updateMember) {
                    updateMember.idMember = v;
                    updateMember.avatarThumb = tmpAvatarThumb;
                    updateMember.client = va;
                    updateMember.updated_at = updated_at;
                    updateMember.created_at = created_at;
                    updateMember.firstname = firstname;
                    updateMember.lastname = lastname;
                    updateMember.role = role;
                    updateMember.login = login;
                    updateMember.facebook = facebook;
                    updateMember.desc = desc;
                    updateMember.email = email;
                    updateMember.github = github;
                    updateMember.linkedin = linkedin;
                    updateMember.twitter = twitter;
                    updateMember.viadeo = viadeo;
                    [localContext saveToPersistentStoreAndWait];
                }
            }
            
            
            Member *existingEntity = [Member findFirstByAttribute:@"idMember" withValue:v];
            NSLog(@"%@",existingEntity.lastname);
            if (!existingEntity)
            {
                NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
                Member *newMember = [Member createInContext:localContext];
                newMember.idMember = v;
                newMember.avatarThumb = tmpAvatarThumb;
                newMember.client = va;
                newMember.updated_at = updated_at;
                newMember.created_at = created_at;
                newMember.firstname = firstname;
                newMember.lastname = lastname;
                newMember.role = role;
                newMember.login = login;
                newMember.facebook = facebook;
                newMember.desc = desc;
                newMember.email = email;
                newMember.github = github;
                newMember.linkedin = linkedin;
                newMember.twitter = twitter;
                newMember.viadeo = viadeo;
                [localContext saveToPersistentStoreAndWait];
            }
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Failed Response : %@", JSON);
    }];
    [operation start];

}

+(Member *)returnMember:(NSString *)idMember {
    Member *personFounded;
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idMember ==[c] %@", idMember];
    personFounded = [Member findFirstWithPredicate:predicate inContext:localContext];
    if (personFounded) {
        return personFounded;
    }
    return personFounded;
}
@end
