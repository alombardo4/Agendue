//
//  FlowViewController.m
//  Agendue
//
//  Created by Alec on 12/18/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "FlowViewController.h"

@interface FlowViewController ()

@end

@implementation FlowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f],
//                                                        NSForegroundColorAttributeName : [UIColor whiteColor]
//                                                        } forState:UIControlStateNormal];
    [self.tabBarController setNeedsStatusBarAppearanceUpdate];
    [self.tabBarController.tabBar setNeedsLayout];
    [self.tabBarController.tabBar setNeedsDisplay];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
