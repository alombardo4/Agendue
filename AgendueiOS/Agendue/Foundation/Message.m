//
//  Message.m
//  Agendue
//
//  Created by Alec on 6/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "Message.h"

@implementation Message
-(id) initWithUser: (NSString *) initUser Subject: (NSString *) initSubject AndContent: (NSString *) initContent
{
    self = [super init];
    user = initUser;
    subject = initSubject;
    content = initContent;
    return self;
}
-(id) initWithUser:(NSString *)initUser AndContent:(NSString *)initContent;
{
    self = [super init];
    user = initUser;
    content = initContent;
    return self;
}

@synthesize user, content, subject, webID;
@end
