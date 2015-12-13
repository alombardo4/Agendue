//
//  iOSRequest.m
//  Agendue
//
//  Created by Alec on 8/5/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "iOSRequest.h"
#import "NSString+WebService.h"
#import "AgendueHTMLParser.h"

@implementation iOSRequest
+(void) requestToPath:(NSString *)path onCompletion:(RequestCompletionHandler)complete
{

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:path] cachePolicy:NSURLCacheStorageAllowedInMemoryOnly timeoutInterval:10];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                                        completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
        if (complete) complete (result, error);
    }];
}

+(void) getLoginPageonCompletion: (RequestCompletionHandler) complete
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/login"]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               if (complete)
                               {
                                complete(result, error);
                               }
                           }];

}

+(void) getUserPageOnCopmletion: (RequestCompletionHandlerData) complete
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/user.json"]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               if (complete)
                               {
                                   complete(data, error);
                               }
                           }];

}

+(void) loginWithUsername: (NSString *) username andPassword: (NSString *) password onCompletion:(RequestCompletionHandler)complete
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/login"]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];

                               NSString *body = @"name=";
                               body = [body stringByAppendingString:[username URLEncode]];
                               body = [body stringByAppendingString:@"&password="];
                               body = [body stringByAppendingString:[password URLEncode]];
                               body = [body stringByAppendingString:@"&authenticity_token="];
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               [request setHTTPMethod:@"POST"];
                               [request addValue:@"application/json" forHTTPHeaderField:@"accept"];
                               [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:request queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   NSString *r2 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   if (complete){
                                     complete(r2, error);
                                   }
                               }];
                           }];




}

+(void) getProjectsForUserOnCompletion:(RequestCompletionHandlerData) complete
{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/projects"]];

    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) complete(data, error);
                           }];
}

+(void) getLandingTasksonCompletion:(RequestCompletionHandlerData) complete
{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/landing.json"]];

    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) complete(data, error);
                           }];
}

+(void) getCalendarOnCompletion:(RequestCompletionHandlerData) complete
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/calendar.json"]];

    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) complete(data, error);
                           }];
}

+(void) getLandingScoreOnCompletion:(RequestCompletionHandlerData) complete
{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/landing/score.json"]];

    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) complete(data, error);
                           }];
}

+(void) getLandingPersonalOnCompletion:(RequestCompletionHandlerData) complete
{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/landing/personal.json"]];

    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) complete(data, error);
                           }];
}

+(void) getLandingIncompleteOnCompletion:(RequestCompletionHandlerData) complete
{

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/landing/incomplete_count.json"]];

    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) complete(data, error);
                           }];
}

+(void) getTasksForUserForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects/%@", projectNum];
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getCompleteTasksForUserForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects/%@/tasks/complete", projectNum];
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getIncompleteTasksForUserForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects/%@/tasks/incomplete", projectNum];
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getIncompletePersonalTasksOnCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/personal_tasks/all/incomplete.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getCompletePersonalTasksOnCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/personal_tasks/all/complete.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getMessagesForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects/%@/messages", projectNum];
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getProductivityScoreOnCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/landing/score.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getWikiForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects/%@/wiki", projectNum];
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getEditWikiForProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects/%@/wiki/edit?", projectNum];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getCanShareProject: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects/%@/shares/canshare", projectNum];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getProjectShares: (NSString *) projectNum onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects/%@/shares.json", projectNum];
    NSLog(url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];

    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {

                                   complete(data, error);
                               }

                           }];
}

+(void) getAllTasksOnCompletion:(RequestCompletionHandlerData)complete
{
    NSString *url = @"https://agendue.com/tasks";
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {
                                   complete(data, error);
                               }

                           }];
}

+(void) getAllIncompleteTasksOnCompletion:(RequestCompletionHandlerData)complete
{
    NSString *url = @"https://agendue.com/tasks/incomplete";
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {
                                   complete(data, error);
                               }

                           }];
}

+(void) getAllCompleteTasksOnCompletion:(RequestCompletionHandlerData)complete
{
    NSString *url = @"https://agendue.com/tasks/complete";
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {
                                   complete(data, error);
                               }

                           }];
}

+(void) getAssignedTasksOnCompletion:(RequestCompletionHandlerData)complete
{
    NSString *url = @"https://agendue.com/tasks/assigned";
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {
                                   complete(data, error);
                               }

                           }];
}

+(void) getAssignedIncompleteTasksOnCompletion:(RequestCompletionHandlerData)complete
{
    NSString *url = @"https://agendue.com/tasks/assigned/incomplete";
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {
                                   complete(data, error);
                               }

                           }];
}

+(void) getAssignedCompleteTasksOnCompletion:(RequestCompletionHandlerData)complete
{
    NSString *url = @"https://agendue.com/tasks/assigned/complete";
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {
                                   complete(data, error);
                               }

                           }];
}

+(void) getDetailsForTask: (NSString *) taskNum onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/tasks/%@", taskNum];
    url = [url stringByAppendingString:@".json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (complete) {
                             complete(data, error);
                               }

                           }];
}

+(void) addProject: (NSString *) projectName onCompletion:(RequestCompletionHandlerData)complete
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/projects"]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];

                               NSString *body = [@"project[name]" URLEncode];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[projectName URLEncode]];
                               body = [body stringByAppendingString:@"&authenticity_token="];
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               [request setHTTPMethod:@"POST"];
                               [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:request queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) complete(data, error);
                               }];
    }];




}

+(void) addMessage: (NSString *) messageContent onCompletion:(RequestCompletionHandlerData)complete
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/projects"]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/messages"]];
                               NSString *body = [@"message[content]" URLEncode];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[messageContent URLEncode]];
                               body = [body stringByAppendingString:@"&authenticity_token="];
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               [newRequest setHTTPMethod:@"POST"];
                               [newRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:newRequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) complete(data, error);
                               }];
                           }];




}


+(void) addDeviceForAPNS: (NSString *) deviceToken onCompletion:(RequestCompletionHandlerData)complete
{
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    NSMutableURLRequest *newRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/devices"]];
    NSString *body = [@"device[os]" URLEncode];
    body = [body stringByAppendingString:@"="];
    body = [body stringByAppendingString:[@"ios" URLEncode]];
    body = [body stringByAppendingString:@"&device[token]="];
    body = [body stringByAppendingString:[deviceToken URLEncode]];
    [newRequest setHTTPMethod:@"POST"];
    [newRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendAsynchronousRequest:newRequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (complete) complete(data, error);
    }];




}

+(void) deleteProject: (NSString *) projectID onCompletion:(RequestCompletionHandlerData)complete
{
    NSString *url = [[NSString alloc] initWithFormat:@"https://agendue.com/projects/%@", projectID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/projects"]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                               NSString *body = @"authenticity_token=";
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               [secondrequest setHTTPMethod:@"DELETE"];
                               [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) complete(data, error);
                               }];
                           }];




}

+(void) editProject: (NSString *) projectID withName: (NSString *) name andShareWith: (NSString *) share onCompletion: (RequestCompletionHandlerData) complete
{
    {
        NSString *url = [[NSString alloc] initWithFormat:@"https://agendue.com/projects/%@", projectID];
        url = [url stringByAppendingString:@".json"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/projects"]];
        NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:backgroundQueue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                                   NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                                   NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

                                   NSString *body = [@"project[name]" URLEncode];
                                   body = [body stringByAppendingString:@"="];
                                   body = [body stringByAppendingString:[name URLEncode]];
                                   body = [body stringByAppendingString:@"&"];
                                   body = [body stringByAppendingString:[@"project[shares]" URLEncode]];
                                   body = [body stringByAppendingString:@"="];
                                   body = [body stringByAppendingString: [share URLEncode]];
                                   body = [body stringByAppendingString:@"&authenticity_token="];
                                   body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                                   [secondrequest setHTTPMethod:@"PUT"];
                                   [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                                   [secondrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                                   [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                       if (complete) {
                                           complete(data, error);
                                       }
                                   }];
        }];

    }

}

+(void) addShare: (NSString *) share toProjectWithId: (NSString *) webID onCompletion: (RequestCompletionHandlerData) complete
{
    {
        NSString *url = [[NSString alloc] initWithFormat:@"https://agendue.com/projects/%@", webID];
        url = [url stringByAppendingString:@".json"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/projects"]];
        NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:backgroundQueue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                                   NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                                   NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

                                   NSString *body = [@"project[shares]" URLEncode];
                                   body = [body stringByAppendingString:@"="];
                                   body = [body stringByAppendingString: [share URLEncode]];
                                   body = [body stringByAppendingString:@"&authenticity_token="];
                                   body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                                   [secondrequest setHTTPMethod:@"PUT"];
                                   [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                                   [secondrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                                   [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                       if (complete) {
                                           complete(data, error);
                                       }
                                   }];
                               }];

    }

}

+(void) logOutonCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [[NSString alloc] initWithFormat:@"https://agendue.com/logout"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/projects"]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

                               NSString *body = @"authenticity_token=";
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               [secondrequest setHTTPMethod:@"POST"];
                               [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) {
                                       complete(data, error);
                                   }
                               }];
                           }];
}
+(void) addTaskName: (NSString *) name withDescription: (NSString *) description assignedTo: (NSString *) assign isCompleted: (bool) completed dueDate: (NSString *) dueDate personalDueDate: (NSString *) personalDueDate label: (NSString *) label toProject: (NSString *) webID onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects/%@", webID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSString *url2 = @"https://agendue.com/tasks";
                               NSString *body = [@"task[name]" URLEncode];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[name URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[description]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[description URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[assignedto]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[assign URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[duedate]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[dueDate URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[personalduedate]" URLEncode]];
                               body = [body stringByAppendingString:@"=\"null\""];
                               NSString *labelVal = @"null";
                               if ([label isEqualToString:@"Red"])
                               {
                                   labelVal = @"1";
                               }
                               else if ([label isEqualToString:@"Green"])
                               {
                                   labelVal = @"2";
                               }
                               else if ([label isEqualToString:@"Blue"])
                               {
                                   labelVal = @"3";
                               }
                               else if ([label isEqualToString:@"Yellow"])
                               {
                                   labelVal = @"4";
                               }
                               else if ([label isEqualToString:@"None"])
                               {
                                   labelVal = @"0";
                               }
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[label]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:labelVal];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[complete]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               if (completed) {
                                   body = [body stringByAppendingString:[@"true" URLEncode]];

                               }
                               else {
                                   body = [body stringByAppendingString:[@"false" URLEncode]];

                               }
                               body = [body stringByAppendingString:@"&authenticity_token="];
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url2]];

                               [secondrequest setHTTPMethod:@"POST"];
                               [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) complete(data, error);
                               }];
                           }];
}

+(void) addPersonalTaskName: (NSString *) name withDescription: (NSString *) description isCompleted: (bool) completed dueDate: (NSString *) dueDate label: (NSString *) label onCompletion: (RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/personal_tasks/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSString *url2 = @"https://agendue.com/personal_tasks";
                               NSString *body = [@"personal_task[title]" URLEncode];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[name URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"personal_task[description]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[description URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"personal_task[duedate]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[dueDate URLEncode]];
                               NSString *labelVal = @"null";
                               if ([label isEqualToString:@"Red"])
                               {
                                   labelVal = @"1";
                               }
                               else if ([label isEqualToString:@"Green"])
                               {
                                   labelVal = @"2";
                               }
                               else if ([label isEqualToString:@"Blue"])
                               {
                                   labelVal = @"3";
                               }
                               else if ([label isEqualToString:@"Yellow"])
                               {
                                   labelVal = @"4";
                               }
                               else if ([label isEqualToString:@"None"])
                               {
                                   labelVal = @"0";
                               }
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"personal_task[label]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:labelVal];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"personal_task[complete]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               if (completed) {
                                   body = [body stringByAppendingString:[@"true" URLEncode]];

                               }
                               else {
                                   body = [body stringByAppendingString:[@"false" URLEncode]];

                               }
                               body = [body stringByAppendingString:@"&authenticity_token="];
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url2]];

                               [secondrequest setHTTPMethod:@"POST"];
                               [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) complete(data, error);
                               }];
                           }];
}




+(void) saveEditedTask: (NSString *) webID withName: (NSString *) name description: (NSString *) description assignment: (NSString *) assign completed: (NSString *) completed duedate: (NSString *) duedate personalDueDate: (NSString *) personalduedate label: (NSString *) label onCompletion:(RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
          [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSString *url2 = [NSString stringWithFormat:@"https://agendue.com/tasks/%@.json", webID];
                               NSString *body = [@"task[name]" URLEncode];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[name URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[description]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[description URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[assignedto]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[assign URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[duedate]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               if (duedate != nil)
                               {
                                   body = [body stringByAppendingString:[duedate URLEncode]];

                               }
                               else
                               {
                                   body = [body stringByAppendingString:[@"null" URLEncode]];
                               }
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[personalduedate]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[personalduedate URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[complete]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:completed];
                               //labels 0rgby
                               NSString *labelVal = @"null";
                               if ([label isEqualToString:@"Red"])
                               {
                                   labelVal = @"1";
                               }
                               else if ([label isEqualToString:@"Green"])
                               {
                                   labelVal = @"2";
                               }
                               else if ([label isEqualToString:@"Blue"])
                               {
                                   labelVal = @"3";
                               }
                               else if ([label isEqualToString:@"Yellow"])
                               {
                                   labelVal = @"4";
                               }
                               else if ([label isEqualToString:@"None"])
                               {
                                   labelVal = @"0";
                               }
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"task[label]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:labelVal];

                               body = [body stringByAppendingString:@"&authenticity_token="];
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url2]];
                               [secondrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                               [secondrequest setHTTPMethod:@"PUT"];
                               [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) {
                                       complete(data, error);
                                   }
                               }];
                           }];
}

+(void) saveEditedPersonalTask: (NSString *) webID withName: (NSString *) name description: (NSString *) description completed: (NSString *) completed duedate: (NSString *) duedate label: (NSString *) label onCompletion:(RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
          [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSString *url2 = [NSString stringWithFormat:@"https://agendue.com/personal_tasks/%@.json", webID];
                               NSString *body = [@"personal_task[title]" URLEncode];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[name URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"personal_task[description]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[description URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"personal_task[duedate]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               if (duedate != nil)
                               {
                                   body = [body stringByAppendingString:[duedate URLEncode]];

                               }
                               else
                               {
                                   body = [body stringByAppendingString:[@"null" URLEncode]];
                               }
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"personal_task[complete]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:completed];
                               //labels 0rgby
                               NSString *labelVal = @"null";
                               if ([label isEqualToString:@"Red"])
                               {
                                   labelVal = @"1";
                               }
                               else if ([label isEqualToString:@"Green"])
                               {
                                   labelVal = @"2";
                               }
                               else if ([label isEqualToString:@"Blue"])
                               {
                                   labelVal = @"3";
                               }
                               else if ([label isEqualToString:@"Yellow"])
                               {
                                   labelVal = @"4";
                               }
                               else if ([label isEqualToString:@"None"])
                               {
                                   labelVal = @"0";
                               }
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"personal_task[label]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:labelVal];

                               body = [body stringByAppendingString:@"&authenticity_token="];
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url2]];
                               [secondrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                               [secondrequest setHTTPMethod:@"PUT"];
                               [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) {
                                       complete(data, error);
                                   }
                               }];
                           }];
}

+(void) completeOrIncompleteTask: (NSString *) webID completed: (NSString *) completed onCompletion:(RequestCompletionHandlerData) complete
{
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
          [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSString *url2 = [NSString stringWithFormat:@"https://agendue.com/tasks/%@.json", webID];
                               NSString *body = [@"task[complete]" URLEncode];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:completed];
                               body = [body stringByAppendingString:@"&authenticity_token="];
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url2]];
                               [secondrequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                               [secondrequest setHTTPMethod:@"PUT"];
                               [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) {
                                       complete(data, error);
                                   }
                               }];
                           }];
}

+(void) deleteTask: (NSString *) taskID onCompletion:(RequestCompletionHandlerData)complete
{
    NSString *url = [[NSString alloc] initWithFormat:@"https://agendue.com/tasks/%@", taskID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/projects"]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
          [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                               NSString *body = @"authenticity_token=";
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               [secondrequest setHTTPMethod:@"DELETE"];
                               [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) {
                                       complete(data, error);
                                   }
                               }];
                           }];




}

+(void) deletePersonalTask: (NSString *) taskID onCompletion:(RequestCompletionHandlerData)complete
{
    NSString *url = [[NSString alloc] initWithFormat:@"https://agendue.com/personal_tasks/%@", taskID];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://agendue.com/projects"]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
          [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
                               NSString *body = @"authenticity_token=";
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               [secondrequest setHTTPMethod:@"DELETE"];
                               [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) {
                                       complete(data, error);
                                   }
                               }];
                           }];




}

+(void) createAccountEmail: (NSString *) email firstName: (NSString *) firstName lastName: (NSString *) lastName password: (NSString *) password passwordConfirm: (NSString *) passwordConfirm onCompletion:(RequestCompletionHandlerData) complete
{
    NSString *firstUrl = @"https://agendue.com/users/new";
    NSString *second = @"https://agendue.com/users";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:firstUrl]];
    NSMutableURLRequest *secondrequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:second]];
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
          [NSURLConnection sendAsynchronousRequest:request
                                       queue:backgroundQueue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSString *result = [[NSString alloc] initWithData: data encoding:NSUTF8StringEncoding];
                               NSString *authenticiyToken = [AgendueHTMLParser getAuthenticityTokenFromHTML:result];
                               NSString *body = @"authenticity_token=";
                               body = [body stringByAppendingString:[authenticiyToken URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"user[name]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[email URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"user[firstname]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[firstName URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"user[lastname]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[lastName URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"user[password]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[password URLEncode]];
                               body = [body stringByAppendingString:@"&"];
                               body = [body stringByAppendingString:[@"user[password_confirmation]" URLEncode]];
                               body = [body stringByAppendingString:@"="];
                               body = [body stringByAppendingString:[passwordConfirm URLEncode]];
                               [secondrequest setHTTPMethod:@"POST"];
                               [secondrequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
                               [secondrequest setValue:@"application/json" forHTTPHeaderField:@"accept"];
                               [NSURLConnection sendAsynchronousRequest:secondrequest queue:backgroundQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                                   if (complete) {
                                       complete(data, error);
                                   }
                               }];
                           }];
}
@end
