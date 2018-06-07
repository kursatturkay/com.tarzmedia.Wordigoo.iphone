//
//  DirectoryUtils.h
//  Wordigoo
//
//  Created by callodiez on 14.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DirectoryUtils : NSObject

+(NSArray*)listContentsInBundleResourceDirectory:(NSString*)directoryWithoutSlash;
@end
