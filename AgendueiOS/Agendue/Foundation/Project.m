//
//  Project.m
//  Agendue
//
//  Created by Alec on 8/5/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "Project.h"

@implementation Project
-(id) initWithName: (NSString *) initName andWebID: (NSString *) initWebID
{
    self = [super init];
    self.name = initName;
    self.webID = initWebID;
    
    return self;
}

-(void) addTask: (Task *) task
{
    [tasks addObject:task];
}
-(void) addTasks: (NSMutableArray *) newTasks
{
    [tasks addObjectsFromArray:newTasks];
}

@synthesize name, dateCreated, webID, tasks, shares;

@end
