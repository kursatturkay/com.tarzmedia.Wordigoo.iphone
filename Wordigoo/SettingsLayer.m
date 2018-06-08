//
//  JoinOnlineLayer.m
//  wordigoo-iphone
//
//  Created by Kursat Turkay on 01.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "SettingsLayer.h"
#import "CCTextField.h"
#import "CCControlExtension.h"
#import "WGScoreCore.h"
#import "WGThemeCore.h"
#import "GlobalDefines.h"

#import "CCNode+Utilities.h"
#import "CCControlButton+Utilities.h"

#import "WGThemeCore.h"
#import "WGSoundCore.h"

@implementation SettingsLayer

+(CCScene*)scene_
{
    CCScene *scene=[CCScene node];
    SettingsLayer *layer=[SettingsLayer node];
    [scene addChild:layer];
    return scene;
}

-(void)setErrorLabel:(NSString*)aerrortext
{
    [self clearErrorLabel];
    CGSize wsz=[[CCDirector sharedDirector]winSize];
    CCLabelBMFont *errLabel=(CCLabelBMFont*)[self getChildByTagRecursive:TAG_JOINONLINE_ERROR_LABEL];
    
    if(!errLabel)
    {
        errLabel=[CCLabelBMFont labelWithString:aerrortext fntFile:@"chalkbuster_30.fnt" width:wsz.width alignment:kCCTextAlignmentCenter];
        [errLabel setTag:TAG_JOINONLINE_ERROR_LABEL];
        [errLabel setPosition:ccp(wsz.width/2,290)];
        [self addChild:errLabel];
        //[errLabel setZOrder:1];
    }
    [errLabel setString:aerrortext];
}

-(void)clearErrorLabel
{
    CCLabelBMFont *errLabel=(CCLabelBMFont*)[self getChildByTagRecursive:TAG_JOINONLINE_ERROR_LABEL];
    if(errLabel)
    {
        [errLabel setString:@""];
        [errLabel cleanup];
    }
}

@end
