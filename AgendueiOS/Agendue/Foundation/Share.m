//
//  Share.m
//  Agendue
//
//  Created by Alec on 6/23/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "Share.h"

@implementation Share
-(id) initWithName: (NSString *) initName;
{
    self = [super init];
    self.name = initName;
    return self;
}


@synthesize name;

@end
