//
//  HardwareUtils.h
//  wordigoo-iphone
//
//  Created by callodiez on 09.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTHardwareUtils : NSObject
{}
+ (NSString *) getDeviceModel;
+(BOOL) isIPad;
+(BOOL)isIPADHD;
@end
