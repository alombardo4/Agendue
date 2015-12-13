//
//  MessagesTableViewController.h
//  Agendue
//
//  Created by Alec on 6/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "Message.h"
#import "MessageDetailViewViewController.h"

@interface MessagesTableViewController : UITableViewController
- (void)setWebID:(id)webID;

@end
