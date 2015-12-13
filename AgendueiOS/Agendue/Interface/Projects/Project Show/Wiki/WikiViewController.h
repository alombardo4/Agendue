//
//  WikiViewController.h
//  Agendue
//
//  Created by Alec on 6/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "EditWikiViewController.h"

@interface WikiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *wikiViewer;
- (void)setProject:(id)project;
@end
