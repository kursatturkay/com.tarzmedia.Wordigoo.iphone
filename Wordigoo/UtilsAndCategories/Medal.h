//
//  Medal.h
//  wordigoo
//
//  Created by Kursat Turkay on 25.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"
#import "ScalableMenuItemImage.h"

@interface Medal : NSObject
{
}
@property(nonatomic,retain) ScalableMenuItemImage* medalSprite;
+(Medal*)sharedMedal;
-(void)initMedalto:(CCNode*)aparent;
-(BOOL)checkandUpgradeLevelSignetByPoint:(double)apoint;
-(void)setRotateRelativeToDevice;

//-(double)nextLevelPoint;//getter
//-(void)setNextLevelPoint;//setter
@end
