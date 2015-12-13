//
//  Message.h
//  Agendue
//
//  Created by Alec on 6/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
-(id) initWithUser: (NSString *) initUser Subject: (NSString *) initSubject AndContent: (NSString *) initContent;
-(id) initWithUser:(NSString *)initUser AndContent:(NSString *)initContent;

@property NSString *user;
@property NSString *subject;
@property NSString *content;
@property NSString *webID;

@end
