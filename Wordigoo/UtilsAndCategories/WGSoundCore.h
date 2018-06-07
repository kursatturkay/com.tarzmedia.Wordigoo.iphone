//
//  WGSoundCore.h
//  wordigoo-iphone
//
//  Created by callodiez on 11.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"

@interface WGSoundCore : NSObject
{
    int soundCounter;
}
+(WGSoundCore*)sharedDirector;
-(void)playSound:(NSString*)musicFile Pitch:(float)pitch Gain:(float)gain;

-(ALuint)playEffectSafeVolume:(NSString*)musicFile;
-(ALuint)playEffectSafeVolume:(NSString*)musicFile pitch:(float)pitch pan:(float)pan gain:(float)gain;


-(BOOL)getMusicMutedFromSettings;
-(void)setMusicMutedToSettings:(BOOL)amuted;

-(BOOL)getChangeMusicOnRotationFromSettings;
-(void)setChangeMusicOnRotationToSettings:(BOOL)achangeMusicOnRotation;

@property (nonatomic,retain)NSMutableArray *soundQueue;
@end
