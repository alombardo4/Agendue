//
//  Project.h
//  Agendue
//
//  Created by Alec on 8/5/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Share.h"
#import "Task.h"

@interface Project : NSObject
-(id) initWithName: (NSString *) name andWebID: (NSString *) webID;
//-(void) addShare: (Share *) share;
-(void) addTask: (Task *) task;
-(void) addTasks: (NSMutableArray *) newTasks;

@property NSString *name;
@property NSDate *dateCreated;
@property NSString *webID;
@property NSMutableArray *tasks;
@property NSMutableArray *shares;
@end
