//
//  Medal.m
//  wordigoo
//
//  Created by Kursat Turkay on 25.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "Medal.h"
#import "GlobalDefines.h"
#import "WGThemeCore.h"
#import "WordigooMacros.h"
#import "GeneralUtilities.h"
#import "KTHardwareUtils.h"

static Medal* sharedStaticMedal=nil;

@implementation Medal
@synthesize medalSprite;

-(id)initSingleton
{
    
    if (self=[super init])
    {
        
    }
    return  self;
}

+(Medal*)sharedMedal
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStaticMedal=[[Medal alloc]initSingleton];
    });
    return sharedStaticMedal;
}

-(void)dealloc
{
    [self.medalSprite removeFromParentAndCleanup:YES];
    [super dealloc];
}

-(void)initMedalto:(CCNode*)aparent
{
    CGSize wsz=[[CCDirector sharedDirector]winSize];
    
    if (medalSprite)
    {
        [self.medalSprite removeAllChildrenWithCleanup:YES];
        [self.medalSprite removeFromParentAndCleanup:NO];
    }
    
    if([KTHardwareUtils isIPad])
    {
        self.medalSprite=[CCSprite spriteWithFile:@"skullmale.png"];
    }
    else
    {
        self.medalSprite=[CCSprite spriteWithFile:@"skullmale-iphone.png"];
    }
    
    //[self.medalSprite setColor:[WGThemeCore getHexagonColor]];
    [self.medalSprite setTag:TAG_MEDAL_SPRITE];
    [self.medalSprite setZOrder:2];
    [self.medalSprite setPosition:ccp(wsz.width/2,wsz.height/2)];
    [aparent addChild:self.medalSprite];
    [self loadLevelStatus];
    
}

-(void)setRotateRelativeToDevice
{
    float rotation_=0;
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    
    BOOL isKnownRotation=(orientation==UIDeviceOrientationPortrait)||(orientation==UIDeviceOrientationPortraitUpsideDown)||
    (orientation==UIDeviceOrientationLandscapeLeft)||(orientation==UIDeviceOrientationLandscapeRight);
    if(!isKnownRotation)orientation=UIDeviceOrientationPortrait;
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            rotation_=0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotation_=180;
            break;
        case UIDeviceOrientationLandscapeLeft:
            rotation_=90;
            break;
        case UIDeviceOrientationLandscapeRight:
            rotation_=-90;
            break;
            
        default:
            break;
    }
    [self.medalSprite setRotation:rotation_];
}

-(void)loadLevelStatus
{
    //NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    //BOOL a=[[[prefs dictionaryRepresentation]allKeys]containsObject:@"levelSignet"];
    
    //if (!a)
    //    [prefs setValue:@"Learner" forKey:@"levelSignet"];
    
    
    NSString *levelSignet=[[NSUserDefaults standardUserDefaults]stringForKey:@"levelSignet"];
    
    CCLabelBMFont *lbl_levelSignet=[CCLabelBMFont labelWithString:levelSignet fntFile:@"chalkbuster_30.fnt"];
    [lbl_levelSignet setZOrder:999999];
    
    CGSize medal_sz_=[medalSprite contentSize];
    [medalSprite addChild:lbl_levelSignet];
    [medalSprite setColor:[WGThemeCore getHexagonColor]];
    [lbl_levelSignet setPosition:ccp(medal_sz_.width/2,medal_sz_.height+lbl_levelSignet.contentSize.height/2)];
    [lbl_levelSignet setColor:[WGThemeCore getHexagonFontColor]];
    [self loadGearsByLevelSignet:levelSignet];
}

-(void)loadGearsByLevelSignet:(NSString*)alevelsignet
{
    SWITCH (alevelsignet)
    {
        CASE (@"WiseMan") {
            [self generateGearbyLevel:10];
            break;
        }
        CASE (@"Certifiable") {
            [self generateGearbyLevel:9];
            break;
        }
        CASE (@"Insane") {
            [self generateGearbyLevel:8];
            break;
        }
        CASE (@"Genius") {
            [self generateGearbyLevel:7];
            break;
        }
        CASE (@"Highly Gifted") {
            [self generateGearbyLevel:6];
            break;
        }
        CASE (@"Mind Leader") {
            [self generateGearbyLevel:5];
            break;
        }
        CASE (@"Mind Reader") {
            [self generateGearbyLevel:4];
            break;
        }
        CASE (@"Thinker") {
            [self generateGearbyLevel:3];
            break;
        }
        CASE (@"Clever") {
            [self generateGearbyLevel:2];
            break;
        }
        CASE (@"Learner") {
            [self generateGearbyLevel:1];
            break;
        }
        DEFAULT {
            break;
        }
    }
    
}

/*level:1..10*/
-(void)generateGearbyLevel:(int)abylevel
{
    float device_ratio=([KTHardwareUtils isIPad])?1.0f:0.5f;
    /*points for gears*/
    NSArray *arr=[NSArray arrayWithObjects:
                  [NSValue valueWithCGPoint:ccp(-40,-10)],
                  [NSValue valueWithCGPoint:ccp(-55,2)],
                  [NSValue valueWithCGPoint:ccp(-70,20)],//turkuaz
                  [NSValue valueWithCGPoint:ccp(-30,-35)],//sarı
                  [NSValue valueWithCGPoint:ccp(-80,-10)],//mavi
                  [NSValue valueWithCGPoint:ccp(-72,-35)],//sarı
                  [NSValue valueWithCGPoint:ccp(19,-10)],
                  [NSValue valueWithCGPoint:ccp(-25,20)],
                  [NSValue valueWithCGPoint:ccp(50,-20)],//grili sütlü kağıt gibi olan büyük
                  [NSValue valueWithCGPoint:ccp(0,0)], nil];
    
    for(int i=0;i<abylevel;i++)
    {
        NSValue *v= [arr objectAtIndex:i];
        CGPoint p=[v CGPointValue];
        p=ccp(p.x*device_ratio,p.y*device_ratio);
        NSString *fn_=[NSString stringWithFormat:@"gear%d.png",i+1];
        CCSprite *gearSprite=[CCSprite spriteWithFile:fn_];
        [gearSprite setScale:.50f];
        [medalSprite addChild:gearSprite];
        
        CGPoint center_=ccp(medalSprite.contentSize.width/2+(10*device_ratio),medalSprite.contentSize.height/2+(60*device_ratio));
        p=ccpAdd(center_, p);
        
        [gearSprite setPosition:p];
        [gearSprite setZOrder:(10-i)];
        int rotation_multiplier=((i%2)==0)?1:-1;
        id a=[CCRotateBy actionWithDuration:(i*3+1) angle:180*rotation_multiplier];
        id b=[CCRotateBy actionWithDuration:(i*3+1) angle:180*(-rotation_multiplier)];
        id seq=[CCSequence actions:a,b, nil];
        id r=[CCRepeatForever actionWithAction:seq];
        [gearSprite runAction:r];
    }
}

/*
 upgrades a higher level of level signet.and clears point to 0
 (levels from lowest to highest:learner, clever, thinker, mind reader, mind leader, highly gifted,genius,insane,certifiable,wiseman)
 */

//getter
-(double)nextLevelPoint
{
    double ret_=[[NSUserDefaults standardUserDefaults]integerForKey:@"nextLevelPoint"];
    return  ret_;
}
//setter
-(void)setNextLevelPoint:(double)newValue
{
    NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
    [prefs setDouble:newValue forKey:@"nextLevelPoint"];
    
}

-(BOOL)checkandUpgradeLevelSignetByPoint:(double)apoint
{
    
    //static double nextLevelPoint=[[NSUserDefaults standardUserDefaults]integerForKey:@"nextLevelPoint"];
    
    if (apoint<self.nextLevelPoint)return NO;
    
    NSUserDefaults *prefs= [NSUserDefaults standardUserDefaults];
    
    NSString *newLevelSignet=nil;
    
    //BOOL isNowLearner=(apoint<1000000);
    BOOL isNowClever=(apoint>=100);
    BOOL isNowThinker=(apoint>=1000);
    BOOL isNowMindReader=(apoint>=5000);
    BOOL isNowMindLeader=(apoint>=10000);
    BOOL isNowHighlyGifted=(apoint>=50000);
    BOOL isNowGenius=(apoint>=100000);
    BOOL isNowInsane=(apoint>=1000000);
    BOOL isNowCertifiable=(apoint>=5000000);
    BOOL isNowWiseMan=(apoint>=10000000);
    
    if(isNowWiseMan)newLevelSignet=@"WiseMan";
    else if(isNowCertifiable)newLevelSignet=@"Certifiable";
    else if(isNowInsane)newLevelSignet=@"Insane";
    else if(isNowGenius)newLevelSignet=@"Genius";
    else if(isNowHighlyGifted)newLevelSignet=@"Highly Gifted";
    else if(isNowMindLeader)newLevelSignet=@"Mind Leader";
    else if(isNowMindReader)newLevelSignet=@"Mind Reader";
    else if(isNowThinker)newLevelSignet=@"Thinker";
    else if(isNowClever)newLevelSignet=@"Clever";
    //else if(isNowLearner)newLevelSignet=@"NowLearner";
    
    if(isNowWiseMan)self.nextLevelPoint=1000000000;//1 milyar
    else if(isNowCertifiable)self.nextLevelPoint=10000000;
    else if(isNowInsane)self.nextLevelPoint=5000000;
    else if(isNowGenius)self.nextLevelPoint=1000000;
    else if(isNowHighlyGifted)self.nextLevelPoint=100000;
    else if(isNowMindLeader)self.nextLevelPoint=50000;
    else if(isNowMindReader)self.nextLevelPoint=10000;
    else if(isNowThinker)self.nextLevelPoint=5000;
    else if(isNowClever)self.nextLevelPoint=1000;
    
    [prefs setValue:newLevelSignet forKey:@"levelSignet"];
    //[prefs setInteger:0 forKey:@"soloGameTotalScore"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    return YES;
}

@end
