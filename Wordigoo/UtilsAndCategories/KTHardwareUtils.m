//
//  HardwareUtils.m
//  wordigoo-iphone
//
//  Created by Kursat Turkay on 09.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "KTHardwareUtils.h"
#import "cocos2d.h"
#import "sys/utsname.h"

@implementation KTHardwareUtils



+ (NSString *) getDeviceModel
{
    NSMutableDictionary *devices = [[NSMutableDictionary alloc] init];
    [devices setObject:@"simulator"                     forKey:@"i386"];
    [devices setObject:@"iPod Touch"                    forKey:@"iPod1,1"];
    [devices setObject:@"iPod Touch Second Generation"  forKey:@"iPod2,1"];
    [devices setObject:@"iPod Touch Third Generation"   forKey:@"iPod3,1"];
    [devices setObject:@"iPod Touch Fourth Generation"  forKey:@"iPod4,1"];
    [devices setObject:@"iPhone"                        forKey:@"iPhone1,1"];
    [devices setObject:@"iPhone 3G"                     forKey:@"iPhone1,2"];
    [devices setObject:@"iPhone 3GS"                    forKey:@"iPhone2,1"];
    [devices setObject:@"iPad"                          forKey:@"iPad1,1"];
    [devices setObject:@"iPad 2"                        forKey:@"iPad2,1"];
    [devices setObject:@"iPhone 4"                      forKey:@"iPhone3,1"];
    [devices setObject:@"iPhone 4S"                     forKey:@"iPhone4"];
    [devices setObject:@"iPhone 5"                      forKey:@"iPhone5"];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    return [devices objectForKey:[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding]];
}

+(BOOL) isIPad
{
#ifdef UI_USER_INTERFACE_IDIOM
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
#endif
    return NO;
}


+(BOOL)isIPADHD
{
    //static int virgin_=YES;
    static BOOL ret_=NO;
    /*
     if (virgin_) {
     NSInteger device = [[CCConfiguration sharedConfiguration] runningDevice];
     virgin_=NO;
     ret_=(device==kCCDeviceiPadRetinaDisplay);
     }
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSInteger device = [[CCConfiguration sharedConfiguration] runningDevice];
        ret_=(device==kCCDeviceiPadRetinaDisplay);
    });
    
    return ret_;
}

@end
