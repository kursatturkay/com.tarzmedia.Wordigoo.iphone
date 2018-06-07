//
//  HelloWorldLayer.h
//  CCAlertviewTest
//
//  Created by Harvey Mills on 6/30/13.
//  Copyright Muzago 2013. All rights reserved.
//  www.muzago.com


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "CCAlertView.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <CCAlertviewDelegate>
{
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
