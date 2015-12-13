//
//  NSString+WebService.m
//  Agendue
//
//  Created by Alec on 8/5/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "NSString+WebService.h"

@implementation NSString (WebService)
-(NSString *)URLEncode
{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}
-(id)JSON
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:nil];
}

@end
