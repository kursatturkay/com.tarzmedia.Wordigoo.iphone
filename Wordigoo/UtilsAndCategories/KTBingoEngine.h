//
//  KTBingoEngine.h
//  wordigoo-iphone
//
//  Created by Kursat Turkay on 10.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KTBingoEngine : NSObject
{
}
+(KTBingoEngine*)sharedEngine;
-(NSString*)randomLetter;

@property (nonatomic,retain) NSMutableString *bingoBag;
@end
