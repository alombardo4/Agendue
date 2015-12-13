//
//  AgendueApplication.m
//  Agendue
//
//  Created by Alec on 8/3/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "AgendueApplication.h"

@implementation AgendueApplication
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:    (NSDictionary *)launchOptions
{
    //load up UI
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    //[[NSUserDefaults standardUserDefaults] boolForKey:@"SettingsShowTutorialOnLaunch"])
    bool logout = [[NSUserDefaults standardUserDefaults] boolForKey:@"logoutSwitch"];
    if (logout == YES)
    {
//        NSString *apnsfilepath = [documentsDirectory stringByAppendingPathComponent:@"apnsid.txt"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];

        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@".txt"];
        [fileManager removeItemAtPath:filePath error:nil];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logoutSwitch"];
    }
    
    UIColor *agendueBlue = [AgendueApplication colorFromHexString: @"#3692d5"];
    UIColor *agendueOrange = UIColorFromRGB(0xffab26);
    UIColor *agendueWhite = UIColorFromRGB(0xffffff);
    [self.window setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
    [self changeTint:agendueBlue secondary:agendueOrange tertiary:agendueWhite];
    Login * login = [storyboard instantiateInitialViewController];
    
    //sign up for push
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    

    return YES;
}

- (void) changeTint: (UIColor *) color secondary: (UIColor *) color2 tertiary: (UIColor *) color3{
    [[UINavigationBar appearance] setBarTintColor:color];
    [[UINavigationBar appearance] setTintColor:color2];
    if ([self isEqualToColor:color2] == true) {
        [self.window setTintColor:[UIColor grayColor]];
    } else {
        [self.window setTintColor:color2];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//    [self.window setTintColor:[UIColor redColor]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *output = [[NSString alloc] initWithFormat:@"%@", deviceToken];
    output = [output stringByReplacingOccurrencesOfString:@"<" withString:@""];
    output = [output stringByReplacingOccurrencesOfString:@">" withString:@""];
    output = [output stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"apnsid.txt"];
    
    [output writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    UIUserNotificationType allowedTypes = [notificationSettings types];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (BOOL)isEqualToColor:(UIColor *)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate( colorSpaceRGB, components );
            
            UIColor *color = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return color;
        } else
            return color;
    };
    
    UIColor *selfColor = convertColorToRGBSpace([UIColor whiteColor]);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:otherColor];
}

@end
