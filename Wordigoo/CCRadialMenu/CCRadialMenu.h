#import <GameKit/GameKit.h>
#import "cocos2d.h"

@interface CCMenu (missing)

-(CCMenuItem *) itemForTouch: (UITouch *) touch;

@end

@interface CCRadialMenu : CCMenu {
    float radius_;
}

+(id) radialMenuWithArray:(NSArray *)items radius:(float)radius;
+(id) radialMenuWithArray:(NSArray *)items radius:(float)radius swirlOutDuration:(float)swirlOutDuration;
+(id) radialMenuWithArray:(NSArray *)items radius:(float)radius swirlOutDuration:(float)swirlOutDuration adjustAnchors:(bool)adjustAnchors;

-(id) initRadialMenuWithArray:(NSArray *)items radius:(float)radius swirlOutDuration:(float)swirlOutDuration adjustAnchors:(bool)adjustAnchors;
-(void) alignItemsRadially;
-(void) swirlItemsRadially:(float)duration;
-(void) swirlItemsRadially:(float)duration adjustAnchors:(bool)adjustAnchors;

@end
