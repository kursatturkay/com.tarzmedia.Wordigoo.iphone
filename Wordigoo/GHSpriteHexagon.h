//
//  GHSpriteHexagon.h
//  cocos2d-ios
//
//  Created by Kursat Turkay on 01.07.2013.
//
//

#import "GHSprite.h"
#import "cocos2d.h"

@interface GHSpriteHexagon : GHSprite<CCTouchOneByOneDelegate>
{
}

@property(nonatomic,retain) NSString *letter;
@property(nonatomic) b2Body *bodybody;
+(NSMutableArray*)selectedHexagons;
+(b2Body*)getBodyForSprite:(GHSpriteHexagon*)spriteOnStage inWorld:(b2World*)world_instance;
- (BOOL)containsTouchLocation:(UITouch *)touch;
@end
