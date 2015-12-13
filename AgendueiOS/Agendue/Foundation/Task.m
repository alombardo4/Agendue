//
//  Task.m
//  Agendue
//
//  Created by Alec on 8/7/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "Task.h"

@implementation Task
-(id) initWithName: (NSString *) initName andWebID: (NSString *) initWebID
{
    self = [super init];
    self.name = initName;
    self.webID = initWebID;
    
    return self;
}
@synthesize name, webID, duedate, description, complete, assignedto, datecomplete, projectname, label, calendarDate, isPersonal, projectID;

- (NSString *) title
{
    return self.name;
}

- (NSString *) stringComplete
{
    if (complete == YES)
    {
        return @"true";
    }
    else
    {
        return @"false";
    }
}

- (UIImage *)imageWithLabel
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 20.0f, 20.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [label CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(NSString *) stringLabel
{
    if ([label isEqual:[UIColor whiteColor]])
    {
        return @"None";
    }
    else if ([label isEqual:[UIColor redColor]])
    {
        return @"Red";
    }
    else if ([label isEqual:[UIColor greenColor]])
    {
        return @"Green";
    }
    else if ([label isEqual:[UIColor blueColor]])
    {
        return @"Blue";
    }
    else if ([label isEqual:[UIColor yellowColor]])
    {
        return @"Yellow";
    }
    else
    {
        return @"None";
    }
}
@end
