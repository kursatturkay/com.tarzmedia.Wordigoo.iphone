//
//  WGThemeCore.h
//  Wordigo
//
//  Created by callodiez on 13.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface WGThemeCore : NSObject
{
    
}

+(void)reShuffleColorIndexes:(bool)forced;
+(void)setForceToGetColors:(BOOL)forced;
+(BOOL)isForceToGetColors;

//+(ccColor3B)getTextColor;
+(ccColor3B)getTitleColor;
//+(ccColor3B)getTipColor;
+(ccColor3B)getHexagonColor;
+(ccColor3B)getHexagonFontColor;
+(ccColor4B)getBackgroundColor;

+(void)initStandardUserDefaults;
+(NSString*)selectedTheme;

//themes/ohmyparrothair.plist
+(void)setSelectedThemeRelativeFileAndExtension:(NSString*)theme;
+(void)setNextSelectedTheme;
+(ccColor3B)currentThemeColor:(int)colorKey;
+(BOOL)isWordPoppedBefore:(NSString*)aword;
+(BOOL)deletePoppedWordsplist;
+(void)resetRankandSyncronize:(BOOL)asyncronize;
+(void)appendWordToPoppedWords:(NSString*)aword;
@end
