//
//  AgendueHTMLParser.h
//  AgendueHTMLParser
//
//  Created by Alec on 8/7/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface AgendueHTMLParser : NSObject
+(NSString *) getAuthenticityTokenFromHTML: (NSString *) page;
+(NSMutableArray *) getTasksFromJSON: (NSData *) data;
+(NSMutableArray *) getSharesFromJSON: (NSData *) data;
@end
