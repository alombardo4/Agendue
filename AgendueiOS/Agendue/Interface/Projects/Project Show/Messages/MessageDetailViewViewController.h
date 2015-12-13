//
//  MessageDetailViewViewController.h
//  Agendue
//
//  Created by Alec on 6/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface MessageDetailViewViewController : UIViewController
-(void)setMessage: (Message *) inputMessage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *senderName;

@end
