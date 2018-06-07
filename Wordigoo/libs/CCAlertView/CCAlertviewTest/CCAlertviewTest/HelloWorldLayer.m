//
//  HelloWorldLayer.m
//  CCAlertviewTest
//
//  Created by Harvey Mills on 6/30/13.
//  Copyright Muzago 2013. All rights reserved.
//  www.muzago.com

#import "HelloWorldLayer.h"

@implementation HelloWorldLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	HelloWorldLayer *layer = [HelloWorldLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init {
	if( (self=[super init]) ) {
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"CCAlertView" fontName:@"HelveticaNeue-Bold" fontSize:64];
        label.position =  ccp( size.width /2 , size.height/2 + 100);
        label.color = ccGREEN;
		[self addChild: label];
        
        CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"by Muzago" fontName:@"HelveticaNeue-Bold" fontSize:36];
        label2.tag = 101;
        label2.color = ccMAGENTA;
        label2.position =  ccp( size.width /2 , size.height/2 + 40);
		[self addChild: label2];

        CCLabelTTF *btnLabel = [CCLabelTTF labelWithString:@"Show Alert" fontName:@"HelveticaNeue-Bold" fontSize:18];
        
        BOOL isIPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
        NSString *normalImg = @"reddarkButton.png"; NSString *selectedImg = @"redlightButton.png";
        if (isIPAD) { normalImg = @"reddarkButton-hd.png"; selectedImg = @"redlightButton-hd.png"; }
        
        CCMenuItemImage *button = [CCMenuItemImage itemWithNormalImage:normalImg selectedImage:selectedImg target:self selector:@selector(showAlert)];
        btnLabel.color = ccWHITE;
        btnLabel.position = ccp(button.contentSize.width * .5, button.contentSize.height * .5);
        [button addChild:btnLabel];
		CCMenu *menu = [CCMenu menuWithItems:button, nil];
		[menu setPosition:ccp( size.width * .5, (size.height * .5) - 50)];
		
		[self addChild:menu];
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

-(void) showAlert
{
	CCAlertView *av = [[CCAlertView alloc] initWithTitle:@"Alert" message:@"CCAlertView by Muzago" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitle:@"OK"];
    [av showAV];
}

#pragma mark CCAlertView delegate method (REQUIRED)
- (void) CCAlertView:(CCLayer *)alertView indexSelected:(int)index {
    if (index == 0) {
        CCLOG(@"CANCEL Pressed");
        CCLabelTTF *label = (CCLabelTTF*)[self getChildByTag:101];
        [label stopAllActions];
    }else if (index == 1) {
        CCLOG(@"OK Pressed");
        
        CCLabelTTF *label = (CCLabelTTF*)[self getChildByTag:101];
        [label stopAllActions];
        
        id scaleDown = [CCScaleTo actionWithDuration:.4 scale:0.5];
        id scaleUp = [CCScaleTo actionWithDuration:.2 scale:1.5];
        id scaleBack = [CCScaleTo actionWithDuration:.2 scale:1.0];
        id combination = [CCSequence actions:scaleDown, scaleUp, scaleBack, nil];
        id repeat = [CCRepeat actionWithAction:combination times:3];
        //id repeat = [CCRepeatForever actionWithAction:combination];
        
        [label runAction:repeat];
    }
}

@end
