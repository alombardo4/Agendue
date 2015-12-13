//
//  AgendueHTMLParser.m
//  AgendueHTMLParser
//
//  Created by Alec on 8/7/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "AgendueHTMLParser.h"

@implementation AgendueHTMLParser

+(NSString *) getAuthenticityTokenFromHTML:(NSString *)page
{
    NSString *authToken = [[NSString alloc] init];
    NSArray *acut = [page componentsSeparatedByString:@"meta content=\""];
    if (acut.count < 3)
    {
        return @"";
    }
    NSString *str = acut[2];
    acut = [str componentsSeparatedByString:@"\" name="];
    authToken = acut[0];
    authToken = [authToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    return authToken;
}

+ (NSMutableArray *) getTasksFromJSON: (NSData *) data
{
    NSMutableArray *_objects = [[NSMutableArray alloc] init];
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *names = [dataDictionary valueForKey:@"name"];
    
    NSArray *webIDs = [dataDictionary valueForKey:@"id"];
    NSArray *descriptions = [dataDictionary valueForKey:@"description"];
    NSArray *assignedTos = [dataDictionary valueForKey:@"assignedto"];
    NSArray *completeds = [dataDictionary valueForKey:@"complete"];
    NSArray *duedates = [dataDictionary valueForKey:@"duedate"];
    NSArray *datecompletes = [dataDictionary valueForKey:@"datecomplete"];
    NSArray *labels = [dataDictionary valueForKey:@"label"];
    NSArray *personals = [dataDictionary valueForKey:@"personal"];
    NSArray *projectids = [dataDictionary valueForKey:@"projectid"];
    if (names.count == 0) {
        Task *task = [[Task alloc] initWithName:@"No tasks..." andWebID:@"-1"];
        [_objects insertObject: task atIndex:0];
    }
    for (int i = 0; i < names.count; i++) {
        Task *task = [[Task alloc] initWithName:names[i] andWebID:webIDs[i]];
        
        if (![descriptions[i] isKindOfClass:[NSNull class]])
        {
            task.description = descriptions[i];
            
        }
        if (![duedates[i] isKindOfClass:[NSNull class]])
        {
            task.duedate = duedates[i];
        }
        if (![assignedTos[i] isKindOfClass:[NSNull class]])
        {
            task.assignedto = assignedTos[i];
        }
        if (![completeds[i] isKindOfClass:[NSNull class]]
            && ((NSString *)(completeds[i])).integerValue == 1) {
            task.complete = YES;
        }
        else {
            task.complete = NO;
        }
        
        if (![personals[i] isKindOfClass:[NSNull class]]
            && ((NSString *)(personals[i])).integerValue == 1) {
            task.isPersonal = YES;
        }
        else {
            task.isPersonal = NO;
        }
        
        if (![datecompletes[i] isKindOfClass:[NSNull class]])
        {
            task.datecomplete = datecompletes[i];
        }
        task.label = [UIColor whiteColor];
        if (![labels[i] isKindOfClass:[NSNull class]])
        {
            switch (((int)[labels[i] integerValue])) {
                case 0:
                    task.label = [UIColor whiteColor];
                    break;
                case 1:
                    task.label = [UIColor redColor];
                    break;
                case 2:
                    task.label = [UIColor greenColor];
                    break;
                case 3:
                    task.label = [UIColor blueColor];
                    break;
                case 4:
                    task.label = [UIColor yellowColor];
                    break;
                default:
                    task.label = [UIColor whiteColor];
                    break;
            }
        }
        if (![projectids[i] isKindOfClass: [NSNull class]]) {
            task.projectID = projectids[i];
        }
        [_objects addObject:task];
    }
    return _objects;
}

+(NSMutableArray *) getSharesFromJSON: (NSData *) data {
    NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return [dataDictionary valueForKey:@"name"];
}

@end
