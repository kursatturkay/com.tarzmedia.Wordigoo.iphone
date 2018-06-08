//
//  WGThemeCore.m
//  Wordigo
//
//  Created by Kursat Turkay on 13.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "WGThemeCore.h"
#import "DirectoryUtils.h"
#import "UIColor+Utils.h"
#import "ccTypes.h"
#import "CCFileUtils.h"
#import "GeneralUtilities.h"
#import "SimpleAudioEngine.h"

static int __hexagonForeColorIndex=-1; //paletteColor1
static int __hexagonFontColorIndex=-1;
static int __backgroundColorIndex=-1;
//static int __textColorIndex=-1;
static int __textTitleColorIndex=-1;
//static int __textTipColorIndex=-1;

static BOOL __forceToGetColors=NO;

@implementation WGThemeCore
{
    
}

static NSString *selectedtheme=NULL;

+(void)setForceToGetColors:(BOOL)forced
{
    __forceToGetColors=forced;
}

+(BOOL)isForceToGetColors
{
    return __forceToGetColors;
}


+(BOOL)isWordPoppedBefore:(NSString*)aword
{
    //NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    //NSString *homePath=NSHomeDirectory();
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath =[documentPaths objectAtIndex:0];
    
    NSString *fn_=[documentsPath stringByAppendingFormat:@"/%@",@"poppedWords.plist"];
    NSDictionary *dic_=[NSDictionary dictionaryWithContentsOfFile:fn_];
    
    BOOL a=[[dic_ allKeys]containsObject:aword];
    
    if (a)
    {
        int r01=arc4random()%2;
        NSString *fn_=[NSString stringWithFormat:@"ohno%d.mp3",r01];
        [[SimpleAudioEngine sharedEngine]playEffect:fn_];
    }
    return a;
}

+(BOOL)deletePoppedWordsplist
{
    BOOL ret_=FALSE;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath =[documentPaths objectAtIndex:0];
    
    NSString *fn_=[documentsPath stringByAppendingFormat:@"/%@",@"poppedWords.plist"];
    //NSDictionary *dic_=[NSDictionary dictionaryWithContentsOfFile:fn_];
    //NSError *err_;
    ret_=[[NSFileManager defaultManager]removeItemAtPath:fn_ error:nil];
    return  ret_;
    //if(err_!=nil)
    //   NSLog(@"Error on deletePoppedWordsplist: Description:%@",err_.debugDescription);
    
    //return (err_==nil);
}

+(void)resetRankandSyncronize:(BOOL)asyncronize
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    [prefs setValue:@"Learner" forKey:@"levelSignet"];
    [prefs setInteger:100 forKey:@"nextLevelPoint"];
    if(asyncronize)
        [prefs synchronize];
}

/*
 aynı kelime bir kere seçilsin diye documents/poppedwords.plist eklemek için
 */
+(void)appendWordToPoppedWords:(NSString*)aword
{
    //NSString *homePath=NSHomeDirectory();
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath =[documentPaths objectAtIndex:0];
    
    NSString *fn_=[documentsPath stringByAppendingFormat:@"/%@",@"poppedWords.plist"];
    BOOL successfulWritten=NO;
    //if (!dic_)
    if([[NSFileManager defaultManager]fileExistsAtPath:fn_])
    {
        NSMutableDictionary *dic_=[NSDictionary dictionaryWithContentsOfFile:fn_];
        [dic_ setObject:aword forKey:aword];
        successfulWritten=[dic_ writeToFile:fn_ atomically:YES];
        
    }
    else
    {
        NSMutableDictionary *dic_=[[NSMutableDictionary alloc]initWithObjectsAndKeys:aword,aword, nil];
        //[dic_ setObject:aword forKey:aword];
        successfulWritten=[dic_ writeToFile:fn_ atomically:YES];
        //int a=0;
    }
    //  dic_=[NSDictionary dictionary];
    
    //BOOL a=[[dic_ allKeys]containsObject:aword];
    
    //BOOL successfulWritten;
    
    // if(!a)
    // {[dic_ setValue:aword forKey:aword];
    //     successfulWritten=[dic_ writeToFile:fn_ atomically:YES];
    // }
}

+(ccColor3B)getTitleColor
{
    //[WGThemeCore besureFirstinitResuffleColorIndexes];
    ccColor3B t=[WGThemeCore currentThemeColor:__textTitleColorIndex];
    return t;
}

/*
+(ccColor3B)getTextColor
{
    //[WGThemeCore besureFirstinitResuffleColorIndexes];
    ccColor3B t=[WGThemeCore currentThemeColor:__textColorIndex];
    return t;
}

+(ccColor3B)getTipColor
{
    //[WGThemeCore besureFirstinitResuffleColorIndexes];
    ccColor3B t=[WGThemeCore currentThemeColor:__textTipColorIndex];
    return t;
}
*/

+(ccColor3B)getHexagonColor
{
    //[WGThemeCore besureFirstinitResuffleColorIndexes];
    ccColor3B t=[WGThemeCore currentThemeColor:__hexagonForeColorIndex];
    return t;
}

+(ccColor3B)getHexagonFontColor
{
    //[WGThemeCore besureFirstinitResuffleColorIndexes];
    ccColor3B t=[WGThemeCore currentThemeColor:__hexagonFontColorIndex];
    return t;
}

/*
 +(void)besureFirstinitResuffleColorIndexes
 {
 static BOOL ever1=NO;
 
 if (!ever1)
 {
 [WGThemeCore reShuffleColorIndexes:NO];
 ever1=YES;
 }
 }
 */

+(ccColor4B)getBackgroundColor
{
    //[WGThemeCore besureFirstinitResuffleColorIndexes];
    [WGThemeCore setForceToGetColors:YES];
    ccColor3B t=[WGThemeCore currentThemeColor:__backgroundColorIndex];
    
    ccColor4B ret_=ccc4(t.r, t.g, t.b, 255);
    return ret_;
}


+(void)initStandardUserDefaults
{
    
    [WGThemeCore resetRankandSyncronize:NO];
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    
    NSString *sel_theme_= [NSString stringWithFormat:@"themes/%@",@"darkmorning"];
    [prefs setValue:sel_theme_ forKey:@"selectedtheme"];
    [prefs setInteger:2 forKey:@"hexagonFontColorIndex"];
    [prefs setInteger:1 forKey:@"hexagonForeColorIndex"];
    [prefs setInteger:5 forKey:@"backgroundColorIndex"];
    [prefs setInteger:1 forKey:@"textColorIndex"];
    [prefs setInteger:1 forKey:@"textTipColorIndex"];
    [prefs setInteger:1 forKey:@"textTitleColorIndex"];
    [prefs synchronize];
}

+(void)reShuffleColorIndexes:(bool)forced
{
    if (forced)
    {
        __hexagonFontColorIndex=randIntReservedBetween(1, 5);
        __hexagonForeColorIndex=randIntReservedBetween(1,5);
        __backgroundColorIndex=randIntReservedBetween(1, 5);
        //__textColorIndex=randIntReservedBetween(1,5);
        //__textTipColorIndex=randIntReservedBetween(1, 5);
        __textTitleColorIndex=randIntReservedBetween(1, 5);
        [[NSUserDefaults standardUserDefaults]setInteger:__hexagonFontColorIndex forKey:@"hexagonFontColorIndex"];
        [[NSUserDefaults standardUserDefaults]setInteger:__hexagonForeColorIndex forKey:@"hexagonForeColorIndex"];
        [[NSUserDefaults standardUserDefaults]setInteger:__backgroundColorIndex forKey:@"backgroundColorIndex"];
        //[[NSUserDefaults standardUserDefaults]setInteger:__textColorIndex forKey:@"textColorIndex"];
        //[[NSUserDefaults standardUserDefaults]setInteger:__textTipColorIndex forKey:@"textTipColorIndex"];
        [[NSUserDefaults standardUserDefaults]setInteger:__textTitleColorIndex forKey:@"textTitleColorIndex"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else
    {
        __hexagonFontColorIndex=[[NSUserDefaults standardUserDefaults]integerForKey:@"hexagonFontColorIndex"];
        __hexagonForeColorIndex=[[NSUserDefaults standardUserDefaults]integerForKey:@"hexagonForeColorIndex"];
        __backgroundColorIndex=[[NSUserDefaults standardUserDefaults]integerForKey:@"backgroundColorIndex"];
        //__textColorIndex=[[NSUserDefaults standardUserDefaults]integerForKey:@"textColorIndex"];
        //__textTipColorIndex=[[NSUserDefaults standardUserDefaults]integerForKey:@"textTipColorIndex"];
        __textTitleColorIndex=[[NSUserDefaults standardUserDefaults]integerForKey:@"textTitleColorIndex"];
    }
}

//eg. ohmyparrothair
+(NSString*)selectedTheme
{
    selectedtheme=[[NSUserDefaults standardUserDefaults]stringForKey:@"selectedtheme"];
    
    if (!selectedtheme)
    {
        selectedtheme= [NSString stringWithFormat:@"themes/%@",@"darkmorning"];
        [[NSUserDefaults standardUserDefaults]setValue:selectedtheme forKey:@"selectedtheme"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [WGThemeCore reShuffleColorIndexes:NO];
    }
    else
    {
        [WGThemeCore reShuffleColorIndexes:NO];
    }
    selectedtheme=[selectedtheme stringByReplacingOccurrencesOfString:@"themes/" withString:@""];
    selectedtheme=[selectedtheme stringByReplacingOccurrencesOfString:@".plist" withString:@""];
    
    return selectedtheme;
}

+(ccColor3B)currentThemeColor:(int)colorKey
{
    NSString *plistfn_=[NSString stringWithFormat:@"themes/%@", [WGThemeCore selectedTheme]];
    NSString *plistpath_=[[NSBundle mainBundle]pathForResource:plistfn_ ofType:@"plist"];
    NSDictionary *dic_=[NSDictionary dictionaryWithContentsOfFile:plistpath_];
    
    NSString *skey=[NSString stringWithFormat:@"paletteColor%d",colorKey];
    skey=[NSString stringWithFormat:@"%@",skey];//#DDEE33 gibi plist verilerinde kare işaretini kullanmamak için
    NSString *tmp1=[NSString stringWithFormat:@"#%@",[dic_ valueForKey:skey]];
    ccColor3B color_=[UIColor colorWithHexString:tmp1];
    
    return color_;
}

+(void)setSelectedThemeRelativeFileAndExtension:(NSString*)theme
{
    selectedtheme=[NSString stringWithFormat:@"themes/%@",theme];
    [[NSUserDefaults standardUserDefaults]setValue:selectedtheme forKey:@"selectedtheme"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [WGThemeCore reShuffleColorIndexes:YES];
}

+(void)setNextSelectedTheme
{
    NSArray *themes=[DirectoryUtils listContentsInBundleResourceDirectory:@"themes"];
    int newID=0;int oldID=0;
    
    int tot=[themes count];
    NSString *curTheme=[WGThemeCore selectedTheme];
    curTheme=[curTheme stringByReplacingOccurrencesOfString:@"themes/" withString:@""];
    
    oldID=[themes indexOfObject:[NSString stringWithFormat:@"%@.plist",curTheme]];
    
    if (oldID==(tot-1))newID=0;
    else
        newID=oldID+1;
    NSString *newtheme=(NSString*)[themes objectAtIndex:newID];
    [WGThemeCore setSelectedThemeRelativeFileAndExtension:newtheme];
}

@end
