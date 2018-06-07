//
//  DirectoryUtils.m
//  Wordigoo
//
//  Created by callodiez on 14.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "DirectoryUtils.h"

@implementation DirectoryUtils

+(NSArray*)listContentsInBundleResourceDirectory:(NSString*)directoryWithoutSlash
{
    NSString *path = [[NSBundle mainBundle]resourcePath];
    path=[path stringByAppendingString:[NSString stringWithFormat:@"/%@/",directoryWithoutSlash]];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *directory = [fileManager contentsOfDirectoryAtPath:path error:nil];
    return directory;
}
@end
