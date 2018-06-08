//
//  CCBoardLayer.m
//  wordible
//
//  Created by Kursat Turkay on 09.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "CCBoardLayer.h"
#import "cocos2d.h"

@implementation CCBoardLayer
-(void)draw
{
    [super draw];
    //CGPoint p2=ccp([self boundingBox].size.width,[self boundingBox].size.height);
    //ccDrawRect(ccp(0,0),p2);
}

//reopen when needed for debug purposes.
/*
-(id)init
{
    self =[[CCBoardLayer alloc]initWithColor:ccc4(255,255,255,255)];
    return self;
}
*/

@end
