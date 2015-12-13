//
//  Task.h
//  Agendue
//
//  Created by Alec on 8/7/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject
-(id) initWithName: (NSString *) initName andWebID: (NSString *) initWebID;
- (UIImage *)imageWithLabel;
-(NSString *) stringLabel;
-(NSString *) title;
-(NSString *) stringComplete;
@property NSString *name;
@property NSString *webID;
@property NSString *description;
@property NSString *assignedto;
@property NSString *duedate;
@property NSString *datecomplete;
@property bool complete;
@property NSString *projectname;
@property UIColor *label;
@property NSDate *calendarDate;
@property bool isPersonal;
@property NSString *projectID;
@end
