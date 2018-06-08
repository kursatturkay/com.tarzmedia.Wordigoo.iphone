//
//  RulesLayer.m
//  CCScrollLayerTest01
//
//  Created by Kursat Turkay on 16.06.2013.
//  Copyright tarzmedia 2013. All rights reserved.
//


// Import the interfaces
#import "RulesLayer.h"
#import "IntroLayer.h"
#import "CCScrollLayer.h"

#import "CCMenuAdvanced.h"
#import "ScalableMenuItemImage.h"

#import "WGThemeCore.h"
// Needed to obtain the Navigation Controller

#import "GlobalDefines.h"

#pragma mark - RulesLayer

// RulesLayer implementation
@implementation RulesLayer

// Helper class method that creates a Scene with the RulesLayer as the only child.
+(CCScene *) scene_
{
	CCScene *scene = [CCScene node];
	RulesLayer *layer = [RulesLayer node];
	[scene addChild: layer];
	return scene;
}

-(NSString*)getPaperNameByDevice:(int)paperno
{
    //NSString *devsuffix_= (IS_IPHONE5)?@"IPhone5":@"IPhone4";
    //NSString *ret_=[NSString stringWithFormat:@"tutorialpages/Paper%d_%@.pvr.ccz",paperno,devsuffix_];
    NSString *ret_=[NSString stringWithFormat:@"tutorialpages/paper%d_portrait.png",paperno];
    return ret_;
}

// on "init" you need to initialize your instance

-(id) init
{
	if( (self=[super initWithColor:ccc4(255, 0, 0, 255)]) ) {
		/*
         CCScrollLayer *lyr1=[CCScrollLayer node];
         CCLayer *page1=[CCLayer node];
         [lyr1 addPage:page1];
         [self addChild:lyr1];
         */
        CGSize sz=[[CCDirector sharedDirector]winSize];
        CCLayer *layer1 = [[CCLayer alloc] init];
        
        //CCLabelTTF *label1 = [[CCLabelTTF alloc] initWithString:@"String One" fontName:@"Arial" fontSize:44];
        CCSprite *spr1=[CCSprite spriteWithFile:[self getPaperNameByDevice:1]];
        [spr1 setPosition:ccp(sz.width/2,sz.height/2)];
        //[spr1 setRotation:-90];
        [layer1 addChild:spr1];
        
        CCLayer *layer2 = [[CCLayer alloc] init];
        //CCLabelTTF *label2 = [[CCLabelTTF alloc] initWithString:@"OLLLEY BE KARDEŞ" fontName:@"Arial" fontSize:44];
        CCSprite *spr2=[CCSprite spriteWithFile:[self getPaperNameByDevice:2]];
        //[spr2 setRotation:-90];
        [spr2 setPosition:ccp(sz.width/2,sz.height/2)];
        [layer2 addChild:spr2];
        
        CCLayer *layer3 = [[CCLayer alloc] init];
        //CCLabelTTF *label2 = [[CCLabelTTF alloc] initWithString:@"OLLLEY BE KARDEŞ" fontName:@"Arial" fontSize:44];
        CCSprite *spr3=[CCSprite spriteWithFile:[self getPaperNameByDevice:3]];
        //[spr3 setRotation:-90];
        [spr3 setPosition:ccp(sz.width/2,sz.height/2)];
        [layer3 addChild:spr3];
        
        CCLayer *layer4 = [[CCLayer alloc] init];
        //CCLabelTTF *label2 = [[CCLabelTTF alloc] initWithString:@"OLLLEY BE KARDEŞ" fontName:@"Arial" fontSize:44];
        CCSprite *spr4=[CCSprite spriteWithFile:[self getPaperNameByDevice:4]];
        //[spr4 setRotation:-90];
        [spr4 setPosition:ccp(sz.width/2,sz.height/2)];
        [layer4 addChild:spr4];
        
        CCLayer *layer5 = [[CCLayer alloc] init];
        //CCLabelTTF *label2 = [[CCLabelTTF alloc] initWithString:@"OLLLEY BE KARDEŞ" fontName:@"Arial" fontSize:44];
        CCSprite *spr5=[CCSprite spriteWithFile:[self getPaperNameByDevice:5]];
        //[spr5 setRotation:-90];
        [spr5 setPosition:ccp(sz.width/2,sz.height/2)];
        [layer5 addChild:spr5];
        
        CCLayer *layer6 = [[CCLayer alloc] init];
        //CCLabelTTF *label2 = [[CCLabelTTF alloc] initWithString:@"OLLLEY BE KARDEŞ" fontName:@"Arial" fontSize:44];
        CCSprite *spr6=[CCSprite spriteWithFile:[self getPaperNameByDevice:6]];
        //[spr5 setRotation:-90];
        [spr6 setPosition:ccp(sz.width/2,sz.height/2)];
        [layer6 addChild:spr6];
        
        ScalableMenuItemImage *m2=[ScalableMenuItemImage itemWithNormalImage:@"buttonReturnback.png" selectedImage:@"buttonReturnback.png" target:self selector:@selector(buttonReturnBackPressed)];
        CCMenuAdvanced *mnu_=[CCMenuAdvanced menuWithItems:m2, nil];
        [layer6 addChild:mnu_];
        [mnu_ alignItemsVertically];
        int mhp2=mnu_.contentSize.height/2;
        [mnu_ setPosition:ccp(sz.width-mnu_.contentSize.width-mhp2,mhp2-10)];
        
        CCScrollLayer *scroll = [[CCScrollLayer alloc] initWithLayers:[NSArray arrayWithObjects:layer1, layer2,layer3,layer4,layer5,layer6,nil] widthOffset:0];
        [scroll setStealTouches:YES];
        [scroll  setPagesIndicatorPosition:ccp(sz.width/2,10)];
        //[self setRotation:90];
        [self addChild:scroll];
	}
	return self;
}

- (void) dealloc
{
	[super dealloc];
}

-(void)buttonReturnBackPressed
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[IntroLayer scene_]]];
}
@end
