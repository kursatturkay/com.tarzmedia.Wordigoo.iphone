//
//  WGSoundCore.m
//  wordigoo-iphone
//
//  Created by Kursat Turkay on 11.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "WGSoundCore.h"


@implementation WGSoundCore
@synthesize soundQueue;

static WGSoundCore* sharedStaticDirector=nil;

-(id)initSingleton
{
    if(self=[super init])
    {
        soundQueue=[NSMutableArray array];
        soundCounter=0;
    }
    return self;
}

+(WGSoundCore*)sharedDirector
{
    if(sharedStaticDirector)
        return sharedStaticDirector;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStaticDirector=[[WGSoundCore alloc]initSingleton];
    });
    
    return sharedStaticDirector;
}

-(void)playSound:(NSString*)musicFile Pitch:(float)pitch Gain:(float)gain
{
    if (soundCounter<10)
    {
        soundCounter++;
        //[[SimpleAudioEngine sharedEngine] setEffectsVolume:1.0];
        //NSLog(@"soundCounter + :%d",soundCounter);
        //CDSoundSource *src=[[[CDAudioManager sharedManager]audioSourceForChannel:kASC_Right]];
        [[SimpleAudioEngine sharedEngine]playEffect:musicFile pitch:pitch pan:0 gain:0.1f];
        //pitch:(pitch_/200.0f) pan:0 gain:0.1f];
        //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onTimeOut:) userInfo:[NSNumber numberWithInt:soundhandle_] repeats:NO];
    }
}
/*
-(void)onTimeOut:(NSTimer*)sender
{
    soundCounter--;
    ALuint soundhandle_= [sender userInfo];
    [[SimpleAudioEngine sharedEngine]stopEffect:soundhandle_];
    
    //NSLog(@"soundCounter - :%d %@",soundCounter,NSStringFromClass([sender class]));
    if (soundCounter==0)
    {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0.0];
    }
    [sender invalidate];
}
*/
//ensures if volume is 1.
-(ALuint)playEffectSafeVolume:(NSString*)musicFile
{
   // if([[SimpleAudioEngine sharedEngine]effectsVolume]<1)
   //     [[SimpleAudioEngine sharedEngine]setEffectsVolume:1.0f];
    
    return [[SimpleAudioEngine sharedEngine]playEffect:musicFile];
    
}

-(ALuint)playEffectSafeVolume:(NSString*)musicFile pitch:(float)pitch pan:(float)pan gain:(float)gain
{
   // if([[SimpleAudioEngine sharedEngine]effectsVolume]<1)
   //     [[SimpleAudioEngine sharedEngine]setEffectsVolume:1.0f];
    
    return [[SimpleAudioEngine sharedEngine]playEffect:musicFile pitch:pitch pan:pan gain:gain];
}

-(BOOL)getMusicMutedFromSettings
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    
    BOOL muteMusic=[prefs boolForKey:@"muteMusic"];
    return (muteMusic);
}

-(void)setMusicMutedToSettings:(BOOL)amuteMusic
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    
    [prefs setBool:amuteMusic forKey:@"muteMusic"];
    [prefs synchronize];
}

-(BOOL)getChangeMusicOnRotationFromSettings
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    
    BOOL changeMusicOnRotation=[prefs boolForKey:@"changeMusicOnRotation"];
    return (changeMusicOnRotation);
}

-(void)setChangeMusicOnRotationToSettings:(BOOL)achangeMusicOnRotation
{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    
    [prefs setBool:achangeMusicOnRotation forKey:@"changeMusicOnRotation"];
    [prefs synchronize];
}

@end
