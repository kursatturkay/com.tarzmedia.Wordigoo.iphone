//
//  UIColor+Utils.h
//  Wordigoo
//
//  Created by callodiez on 17.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ccTypes.h"
@interface UIColor (Utils)
+(UIColor *)colorFromRGBHexString:(NSString *)colorString;
+(ccColor3B)colorWithHexString: (NSString *) stringToConvert;
@end
