//
//  GHSpriteHexagon.m
//  cocos2d-ios
//
//  Created by callodiez on 01.07.2013.
//
//

#import "GHSpriteHexagon.h"
#import "GlobalDefines.h"

@implementation GHSpriteHexagon
@synthesize letter,bodybody;

static NSMutableArray *selectedHexagons_=NULL;

+(NSMutableArray*)selectedHexagons
{
    @synchronized(self)
    {
        if (selectedHexagons_==nil)
            selectedHexagons_=[[NSMutableArray alloc]init];
    }
    return selectedHexagons_;
}

+(b2Body*)getBodyForSprite:(GHSpriteHexagon*)spriteOnStage inWorld:(b2World*)world_instance
{
    
    for(b2Body *b=world_instance->GetBodyList();b;b=b->GetNext())
    {
        GHSpriteHexagon *spr=(GHSpriteHexagon*)b->GetUserData();
        
        if(spr==spriteOnStage){
            return b;
        }
    }
    return nil;
}

/*
 - (BOOL)containsTouchLocation:(UITouch *)touch {
 CGPoint p = [self convertTouchToNodeSpaceAR:touch];
 CGSize size = self.contentSize;
 if(!CGSizeEqualToSize(self.boundingBox.size, CGSizeZero))
 size = self.boundingBox.size;
 CGRect r = CGRectMake(-size.width*0.5, -size.height*0.5, size.width/1.5, size.height/1.5);
 return CGRectContainsPoint(r, p);
 }
 */

- (BOOL)containsTouchLocation:(UITouch *)touch
{
    CGPoint p_=[touch locationInView:[touch view]];
    p_=[[CCDirector sharedDirector]convertToGL:p_];
    b2Body *b_=[self bodybody];
    b2Fixture *b_fixture_=b_->GetFixtureList();
    
    b2Vec2 locationWorld_ = b2Vec2(p_.x/PTM_RATIO, p_.y/PTM_RATIO);
    BOOL ret_=(b_fixture_->TestPoint(locationWorld_));
    return ret_;
    
    
}
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    //NSLog(@"ccTouchBegan triggered");
    return ([self containsTouchLocation:touch]);
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    //NSLog(@"ccTouchEnded");
    // CCSpriteFrameCache *cache=[CCSpriteFrameCache sharedSpriteFrameCache];
    //  CCSpriteFrame *frame1=[cache spriteFrameByName:@"6gensari"];
    //  [self setDisplayFrame:frame1];
    //[[self parent]removeChild:self cleanup:YES];
}
-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    //NSLog(@"GHSpriteHexagon::ccTouchMoved");
}
-(void)onEnter
{
    [[[CCDirector sharedDirector]touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:NO];
    [super onEnter];
}
-(void)onExit
{
    [[[CCDirector sharedDirector]touchDispatcher]removeDelegate:self];
    [super onExit];
}
@end
