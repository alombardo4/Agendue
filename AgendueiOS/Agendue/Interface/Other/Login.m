//
//  Login.m
//  Agendue
//
//  Created by Alec on 12/18/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "Login.h"
@interface Login()
{
    NSString *color1, *color2, *color3;
}
@end

@implementation Login
- (bool) userInfoFound
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@".txt"];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];

    if ([str length] > 0)
    {
        return true;
    }
    else
    {
        return false;
    }
}

- (IBAction)runLogin:(id)sender {
    [self.view endEditing:YES];
    self.login.hidden = YES;
    NSString *userEmail = _email.text;
    NSString *userPassword = _password.text;
    if ([userEmail isEqualToString:@""] || [userPassword isEqualToString:@""]) {
        self.signInButton.hidden = NO;
        self.signUpButton.hidden = NO;
        UIAlertView *bad = [[UIAlertView alloc] initWithTitle:@"Bad Login" message:@"Your username or password was incorrect." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [bad show];

    
    }
    else {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            [iOSRequest getLoginPageonCompletion:^(NSString *returnval, NSError *er) {
                if ([returnval rangeOfString:@"logout"].length > 0) {
                    
                }
                else {
                    dispatch_queue_t main_queue = dispatch_get_main_queue();
                    dispatch_async(main_queue, ^{
                        [iOSRequest loginWithUsername:userEmail andPassword:userPassword onCompletion:^(NSString *ret, NSError *err) {
                            dispatch_queue_t main_queue = dispatch_get_main_queue();
                            dispatch_async(main_queue, ^{
                                bool cont = NO;
                                if([ret rangeOfString:@"shares"].length > 0) {
                                    cont = YES;
                                }
                                dispatch_async(main_queue, ^{
                                    if (cont == YES) {
                                        NSString *output = [[NSString alloc] initWithFormat:@"%@\n%@", userEmail, userPassword ];
                                        
                                        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                        NSString *documentsDirectory = [paths objectAtIndex:0];
                                        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@".txt"];
                                        
                                        [output writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
                                        //register for notifications
                                        NSString *apnsfilepath = [documentsDirectory stringByAppendingPathComponent:@"apnsid.txt"];
                                        NSString *apnstoken = [NSString stringWithContentsOfFile:apnsfilepath encoding:NSUTF8StringEncoding error:NULL];
                                        dispatch_queue_t main_queue = dispatch_get_main_queue();
                                        dispatch_async(main_queue, ^{
                                            if (apnstoken != nil && ![[apnstoken stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                                                [iOSRequest addDeviceForAPNS:apnstoken onCompletion:^(NSData *data, NSError *err) {
                                                    //
                                                }];
                                            }
                                        });
                                        //switch to app
                                        [self getColors];
                                        [self performSegueWithIdentifier:@"SegueToApp" sender:self];
                                    }
                                    else {
                                        UIAlertView *bad = [[UIAlertView alloc] initWithTitle:@"Bad Login" message:@"Your username or password was incorrect." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                                        [bad show];
                                        self.signInButton.hidden = NO;
                                        self.signUpButton.hidden = NO;
                                    
                                    }
                                });
                            });
                            
                        }];
                    });
                }
                
            }];

        });
    }
    
    self.login.hidden = NO;

}

-(void) newLogin
{
            
}
         
- (id)initWithFrame:(CGRect)frame
{
//    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
    Reachability *netReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [netReach currentReachabilityStatus];
    if (status == 0)
    {
        [self performSegueWithIdentifier:@"NoInternetConnection" sender:self];
    }
    else
    {
        if ([self userInfoFound])
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@".txt"];
            NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
            NSArray *parts = [str componentsSeparatedByString:@"\n"];
            [iOSRequest loginWithUsername:parts[0] andPassword:parts[1] onCompletion:^(NSString *ret, NSError *err) {
                dispatch_queue_t main_queue = dispatch_get_main_queue();
                dispatch_async(main_queue, ^{
                    bool cont = NO;
                    if([ret rangeOfString:@"shares"].length > 0) {
                        cont = YES;
                    }
                    dispatch_async(main_queue, ^{
                        if (cont == YES) {
                            NSString *apnsfilepath = [documentsDirectory stringByAppendingPathComponent:@"apnsid.txt"];
                            NSString *apnstoken = [NSString stringWithContentsOfFile:apnsfilepath encoding:NSUTF8StringEncoding error:NULL];

                            dispatch_queue_t main_queue = dispatch_get_main_queue();
                            dispatch_async(main_queue, ^{
                                if (apnstoken != nil && ![[apnstoken stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
                                    [iOSRequest addDeviceForAPNS:apnstoken onCompletion:^(NSData *data, NSError *err) {
                                        //
                                    }];
                                }

                            });
                            [self getColors];

                        }
                        else {
                            UIAlertView *bad = [[UIAlertView alloc] initWithTitle:@"Bad Login" message:@"Your username or password was incorrect." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                            self.signInButton.hidden = NO;
                            self.signUpButton.hidden = NO;
                            [bad show];
                        }
                    });
                });
                 
            }];
        }
        else
        {
            self.signInButton.hidden = NO;
            self.signUpButton.hidden = NO;
            [self.view setNeedsLayout];
            [self.view setNeedsDisplay];
        }
    }
}
-(void) getColors {
    AgendueApplication *app = (AgendueApplication *)[[UIApplication sharedApplication] delegate];
    color1 = @"#3692d5";
    color2 = @"#ffab26";
    color3 = @"#ffffff";
    [iOSRequest getUserPageOnCopmletion:^(NSData *data, NSError *error) {
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRange range = [string rangeOfString:@"primary_color"];
        if (range.location != NSNotFound) { //found
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSString *tempcolor1 = [dataDictionary valueForKey:@"primary_color"];
            NSString *tempcolor2 = [dataDictionary valueForKey:@"secondary_color"];
            NSString *tempcolor3 = [dataDictionary valueForKey:@"tertiary_color"];
            if (!([tempcolor1 isEqualToString:color1] && [tempcolor2 isEqualToString:color1] && [tempcolor3 isEqualToString:color1])) {
                color1 = tempcolor1;
                color2 = tempcolor2;
                color3 = tempcolor3;
            }
        }

        UIColor *uicolor1 = [AgendueApplication colorFromHexString:color1];
        UIColor *uicolor2 = [AgendueApplication colorFromHexString:color2];
        UIColor *uicolor3 = [AgendueApplication colorFromHexString:color3];
        [app changeTint:uicolor1 secondary:uicolor2 tertiary:uicolor3];
        [self performSegueWithIdentifier:@"SegueToApp" sender:self];

    }];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
