//
//  KTInternetUtils.h
//  wordigoo-iphone
//
//  Created by callodiez on 01.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTInternetUtils : NSObject
//@property (nonatomic,assign)BOOL isOnline;
-(BOOL) isOnline;
//+ (BOOL)connectedToInternet;
+(KTInternetUtils*)standartUtils;
@end
