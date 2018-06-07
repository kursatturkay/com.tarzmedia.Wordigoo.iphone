//
//  PhotoSprite.m
//  wordigoo-iphone
//
//  Created by callodiez on 15.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "PhotoSprite.h"

@implementation PhotoSprite

-(id)init
{
    if(self=[super init])
    {
        _isDragging=YES;
        _isClicked=NO;
        _isActionRunning=NO;
    }
    return self;
}

-(void)onEnter
{
    [[[CCDirector sharedDirector]touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint p1=[touch locationInView:[touch view]];
    p1=[[CCDirector sharedDirector]convertToGL:p1];
    
    if (CGRectContainsPoint(self.boundingBox, p1))
    {
        _isDragging=YES;
        _isClicked=YES;
        
        return YES;
    }
    
    return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    _isClicked=NO;
    CGPoint p1=[touch previousLocationInView:[touch view]];
    CGPoint p2=[touch locationInView:[touch view]];
    p1=[[CCDirector sharedDirector]convertToGL:p1];
    p2=[[CCDirector sharedDirector]convertToGL:p2];
    CGPoint diff=ccpSub(p1, p2);
    //CGFloat tmp= ccpDistance(p1, p2);
    CGPoint p=ccpSub(self.position, diff);
    //int r=self.rotation;
    //int mr=(r % 180);
    //CCLOG(@"x:%f,y:%f,r:%d",p.x,p.y,mr);
    
   // BOOL b1=((p.x>=145)&&(p.x<=175)&&(p.y>=175)&&(p.y<=305));
   // if (b1)
        [self setPosition:p];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    /*
    if(_isClicked&&(!_isActionRunning))
    {
        _isActionRunning=YES;
        id a=[CCRotateBy actionWithDuration:.9 angle:90];
        id ea=[CCEaseElasticOut actionWithAction:a period:0.3f];
        id b=[CCCallFuncN actionWithTarget:self selector:@selector(animationEnded)];
        id s1=[CCSequence actions:ea,b, nil];
        [self runAction:s1];
    }
     */
}
-(void)animationEnded
{
    _isActionRunning=NO;
}

@end
