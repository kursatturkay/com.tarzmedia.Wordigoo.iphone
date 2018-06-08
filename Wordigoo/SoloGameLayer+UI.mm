//
//  SoloGameLayer+UI.m
//  wordible
//
//  Created by Kursat Turkay on 09.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//
#import "WGThemeCore.h"

#import "SoloGameLayer+UI.h"
#import "NSString+Utils.h"
#import "CCLabelBMFont+Capacity.h"

#import "SoloGameLayer.h"
#import "GHSpriteHexagon.h"
#import "cocos2d.h"
#import "GlobalDefines.h"
#import "CCBoardLayer.h"
#import "IntroLayer.h"
#import "SimpleAudioEngine.h"

#import "CCMenuAdvanced.h"
#import "ScalableMenuItemImage.h"
#import "WGSoundCore.h"

#import "WordDescriptionLayer.h"

@implementation SoloGameLayer (UI)

-(void)initBoard
{
    //[[self cupSprite]setVisible:NO];
    //CGSize sz=[[CCDirector sharedDirector]winSize];
    CCBoardLayer *score_layer_=[CCBoardLayer node];
    [score_layer_ setTag:TAG_SOLO_SCORE_MENU_LAYER];
    [score_layer_ changeWidth:200 height:50];
    [self addChild:score_layer_];
    //[score_layer_ setColor:ccc3(255, 0, 0)];
    
    //scoreboard
    CCLabelBMFont *score_label_=[CCLabelBMFont labelWithString:@"0" fntFile:@"chalkbuster_30.fnt"];
    [score_label_ setTag:TAG_SOLO_SCORE_LABEL];
    [score_label_ setColor:[WGThemeCore getTitleColor]];
    [score_layer_ addChild:score_label_];
    CGPoint p_tmp_=ccp(score_layer_.contentSize.width/2-80,score_layer_.contentSize.height/2+70);
    [score_label_ setPosition:p_tmp_];
    
    //found words board
    CCLabelBMFont *foundword_label_=[CCLabelBMFont labelWithString:@"?" fntFile:@"chalkbuster_30.fnt"];
    [foundword_label_ setTag:TAG_FOUNDWORD_LABEL];
    [foundword_label_ setColor:[WGThemeCore getTitleColor]];

    [score_layer_ addChild:foundword_label_];
    p_tmp_=ccp(score_layer_.contentSize.width/2,(score_layer_.contentSize.height/2)+70);
    [foundword_label_ setPosition:p_tmp_];
    
    CGSize wsz = [[CCDirector sharedDirector] winSize];
    
    //SOL ALT DÜĞME
    ScalableMenuItemImage *m5_on=[ScalableMenuItemImage itemWithNormalImage:@"buttonCloneOn.png"
                                                  selectedImage:@"buttonCloneOn.png"];
    ScalableMenuItemImage *m5_off=[ScalableMenuItemImage itemWithNormalImage:@"buttonCloneOff.png"
                                                   selectedImage:@"buttonCloneOff.png"];
    
    CCMenuItemToggle *m5=[CCMenuItemToggle itemWithTarget:self selector:@selector(buttonClonePressed:) items:m5_on,m5_off, nil];
    [m5 setTag:TAG_TOGGLE_CLONE_MENUITEM];
    
    CCMenuAdvanced *menu1_=[CCMenuAdvanced menuWithItems:m5, nil];
    [menu1_ setTag:TAG_CLONE_BUTTON_MENU];
    [menu1_ alignItemsHorizontally];
    [self addChild:menu1_];
    [menu1_ setPosition:ccp(10,10)];
    
    //SOL ÜST DÜĞME
    ScalableMenuItemImage *buttonReturnback=[ScalableMenuItemImage itemWithNormalImage:@"buttonReturnback.png"
                                                             selectedImage:@"buttonReturnback.png"
                                                                    target:self selector:@selector(buttonReturnbackPressed)];
    
    CCMenuAdvanced *menu2_=[CCMenuAdvanced menuWithItems:buttonReturnback, nil];
    [menu2_ setTag:TAG_CORNER_MENU2];
    [menu2_ alignItemsHorizontally];
    [self addChild:menu2_];
    [menu2_ setPosition:ccp(10,wsz.height-10-(buttonReturnback.contentSize.height))];
    
    //SAĞ ALT DÜĞME
    /*
    ScalableMenuItemImage *buttonNextTheme=[ScalableMenuItemImage itemWithNormalImage:@"buttonNextTheme.png"]
                                                            selectedImage:@"buttonNextTheme.png"]
                                                                   target:self selector:@selector(buttonNextThemePressed)];
    */
    ScalableMenuItemImage *mBomb_on=[ScalableMenuItemImage itemWithNormalImage:@"buttonBombOn.png"
                                                     selectedImage:@"buttonBombOn.png"];
    ScalableMenuItemImage *mBomb_off=[ScalableMenuItemImage itemWithNormalImage:@"buttonBombOff.png"
                                                      selectedImage:@"buttonBombOff.png"];
    
    CCMenuItemToggle *mBomb=[CCMenuItemToggle itemWithTarget:self selector:@selector(buttonBombPressed) items:mBomb_on,mBomb_off, nil];
    [mBomb setTag:TAG_TOGGLE_BOMB_MENUITEM];

    
    CCMenuAdvanced *menu3_=[CCMenuAdvanced menuWithItems:mBomb, nil];
    [menu3_ setTag:TAG_CORNER_MENU3];
    [menu3_ alignItemsHorizontally];
    [self addChild:menu3_];
    [menu3_ setPosition:ccp(wsz.width-10-(buttonReturnback.contentSize.width),10)];
    
    
    //SAĞ ÜST DÜĞME
    ScalableMenuItemImage *buttonWordDescription=[ScalableMenuItemImage itemWithNormalImage:@"buttonWordDescription.png"
                                                                        selectedImage:@"buttonWordDescription.png"
                                                                               target:self selector:@selector(buttonWordDescriptionPressed)];
    
    CCMenuAdvanced *menu4_=[CCMenuAdvanced menuWithItems:buttonWordDescription, nil];
    [menu4_ setTag:TAG_CORNER_MENU4];
    [menu4_ alignItemsHorizontally];
    [self addChild:menu4_];
    [menu4_ setPosition:ccp(wsz.width-10-(buttonReturnback.contentSize.width),wsz.height-10-(buttonReturnback.contentSize.height))];

    
}
-(void)buttonWordDescriptionPressed
{
    [self saveSoloGameState];

    NSString *selword_=[self lastFoundWord];

    if([selword_ length]>2)
        [WordDescriptionLayer setSelectedWord:selword_];
    
    [WordDescriptionLayer setBackScene:@"SoloGameLayer"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionSlideInR transitionWithDuration:1 scene:[WordDescriptionLayer scene_]]];
}

-(void)buttonClonePressed:(id)Sender
{
    [self setIsCloneMode:(![self isCloneMode])];
    
    if([self isCloneMode])
    {
        int r01=arc4random()%5;
        NSString *fn_=[NSString stringWithFormat:@"goat%d.mp3",r01];
        [[SimpleAudioEngine sharedEngine]playEffect:fn_];
    }
    else
    {
        [[WGSoundCore sharedDirector]playEffectSafeVolume:@"cloneCancelled.mp3"];
        [self.cloneSprite stopAllActions];
        ccColor3B c_=[WGThemeCore getHexagonColor];
        [self.cloneSprite runAction:[CCTintTo actionWithDuration:0.5f red:c_.r green:c_.g blue:c_.b]];
        [self setCloneSprite:NULL];
    }
}
-(void)buttonReturnbackPressed
{
    [self saveSoloGameState];
    [[WGSoundCore sharedDirector]playEffectSafeVolume:@"hex0.mp3"];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionSlideInL transitionWithDuration:1 scene:[IntroLayer scene_]]];
}

-(void)buttonBombPressed
{
    /*
     [self saveSoloGameState];
     [WGThemeCore setNextSelectedTheme];
     [[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[SoloGameLayer scene]]];
     */
    [self setIsBombMode:(![self isBombMode])];
    
    if([self isBombMode])
    {
        [[WGSoundCore sharedDirector]playEffectSafeVolume:@"dynamiteTriggered.mp3"];
        //[[WGSoundCore sharedDirector]playEffectSafeVolume:@"cloneCancelled.mp3"];
        //[self.cloneSprite stopAllActions];
        //[self.cloneSprite runAction:[CCTintTo actionWithDuration:0.5f red:255 green:255 blue:255]];
        //[self setCloneSprite:NULL];
    }
    else
    {
    [[WGSoundCore sharedDirector]playEffectSafeVolume:@"dynamiteCancelled.mp3"];
    }
    
}
-(void)shakeButtonPressed
{
    static BOOL isShakeFinished_=YES;
    //b2Body *cupBody= [GHSpriteHexagon getBodyForSprite:(GHSpriteHexagon*)cupSprite inWorld:world];
    //cupBody->ApplyForce( b2Vec2(200,0), cupBody->GetWorldCenter() );
    
    id a0=[CCCallBlock actionWithBlock:^{isShakeFinished_=NO;}];
    id a1=[CCMoveBy actionWithDuration:0.05f position:ccp(10,10)];
    id a2=[CCMoveBy actionWithDuration:0.05f position:ccp(-20,-20)];
    id a3=[CCMoveBy actionWithDuration:0.05f position:ccp(10,10)];
    id a4=[CCCallBlock actionWithBlock:^{isShakeFinished_=YES;}];
    id s1=[CCSequence actions:a0,a1,a2,a3,a1,a2,a3,a4, nil];
    
    if (isShakeFinished_)
        [cupSprite runAction:s1];
}

-(void)rePositionBoard:(UIDeviceOrientation)orientation
{
    CGSize sz=[[CCDirector sharedDirector]winSize];
    CGPoint loc_score_;
    
    CCLayer *score_layer_=(CCLayer*)[self getChildByTag:TAG_SOLO_SCORE_MENU_LAYER];
    CCMenuAdvanced *menu1_=(CCMenuAdvanced*)[self getChildByTag:TAG_CLONE_BUTTON_MENU];
    CCMenuAdvanced *menu2_=(CCMenuAdvanced*)[self getChildByTag:TAG_CORNER_MENU2];
    CCMenuAdvanced *menu3_=(CCMenuAdvanced*)[self getChildByTag:TAG_CORNER_MENU3];
    CCMenuAdvanced *menu4_=(CCMenuAdvanced*)[self getChildByTag:TAG_CORNER_MENU4];
    
    float rotation_=0;
        
    switch (orientation) {
        case UIDeviceOrientationPortrait://score_layer_.contentSize menu_sz_
            loc_score_=ccp(sz.width/2-score_layer_.contentSize.width/2,sz.height-(score_layer_.contentSize.height)-60);
            rotation_=0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            loc_score_=ccp(sz.width/2-score_layer_.contentSize.width/2,60);
            rotation_=180;
            break;
        case UIDeviceOrientationLandscapeLeft:
            loc_score_=ccp(sz.width-(score_layer_.contentSize.width)+20,sz.height/2-score_layer_.contentSize.height/2);
            rotation_=90;
            break;
        case UIDeviceOrientationLandscapeRight:
            //loc_buttons_=ccp((sz.width)-(menu_sz_.width/2)-35,sz.height/2-menu_sz_.height/2);
            loc_score_=ccp(-20,sz.height/2-score_layer_.contentSize.height/2);
            rotation_=-90;
            break;
            
        default:
            break;
    }
    //loc_buttons_=[[CCDirector sharedDirector]convertToGL:loc_buttons_];
    [score_layer_ setRotation:rotation_];
    [score_layer_ setPosition:loc_score_];
    
    [menu1_ setRotation:rotation_];
    [menu2_ setRotation:rotation_];
    [menu3_ setRotation:rotation_];
    [menu4_ setRotation:rotation_];
    
    //[menu_ setPosition:loc_buttons_];
    //[menu_ setRotation:rotation_];
    /*
     id a=[CCRotateTo actionWithDuration:2 angle:rotation_];
     [menu_ runAction:a];
     
     */
}

-(void)setScoreLabel:(NSString*)score
{
    CCLayer *score_layer_=(CCLayer*)[self getChildByTag:TAG_SOLO_SCORE_MENU_LAYER];
    CCLabelBMFont *score_label_=(CCLabelBMFont*)[score_layer_ getChildByTag:TAG_SOLO_SCORE_LABEL];
    
    NSNumberFormatter *formatter=[NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    score=[formatter stringFromNumber:[NSNumber numberWithInteger:[score integerValue]]];
    [formatter release];
    
    [score_label_ setString:score];
    
}


-(void)setFoundWordLabel:(NSString*)foundword
{
    CCLayer *score_layer_=(CCLayer*)[self getChildByTag:TAG_SOLO_SCORE_MENU_LAYER];
    CCLabelBMFont *score_label_=(CCLabelBMFont*)[score_layer_ getChildByTag:TAG_FOUNDWORD_LABEL];
    [score_label_ setString:foundword];
    
}

-(void)saveSoloGameState
{
    int x,y;
    NSString *locationQueue=[NSString string];
    NSString *letterQueue=[NSString string];
    
    [[CCDirector sharedDirector]pause];
    
    for(b2Body *b=world->GetBodyList();b;b=b->GetNext())
    {
        GHSpriteHexagon *cisim_= (GHSpriteHexagon*)b->GetUserData();
        if(!b)break;
        NSString *clsname_=NSStringFromClass([cisim_ class]);
        
        if (![clsname_ isEqualToString:@"GHSpriteHexagon"])
            continue;
        
        x=b->GetPosition().x*PTM_RATIO;
        y=b->GetPosition().y*PTM_RATIO;
        locationQueue=[locationQueue stringByAppendingString:[NSString stringWithFormat:@"%d,%d ",x,y]];
        letterQueue=[letterQueue stringByAppendingString:[NSString stringWithFormat:@"%@ ",cisim_.letter]];
    }
    
    locationQueue=[locationQueue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([locationQueue length]>0)
    {
        [[NSUserDefaults standardUserDefaults]setValue:locationQueue forKey:@"soloGameHexagonStates"];
        [[NSUserDefaults standardUserDefaults]setValue:letterQueue forKey:@"soloGameHexagonLetters"];
        [[NSUserDefaults standardUserDefaults]setInteger:[self totalScore] forKey:@"soloGameTotalScore"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    [[CCDirector sharedDirector]resume];
    
}

-(void)loadSoloGameState
{
    NSString *location_queue=NULL;
    NSString *letter_queue=NULL;
    
    // NSObject *alocation_queue=[[NSUserDefaults standardUserDefaults]valueForKey:@"soloGameHexagonStates"];
    [self setTotalScore:[[NSUserDefaults standardUserDefaults]integerForKey:@"soloGameTotalScore"]];
    NSString *score_=[NSString stringWithFormat:@"%d",[self totalScore]];
    [self setScoreLabel:score_];
    
    location_queue=[[NSUserDefaults standardUserDefaults]objectForKey:@"soloGameHexagonStates"];
    if (!location_queue)return;
    
    letter_queue=[[NSUserDefaults standardUserDefaults]objectForKey:@"soloGameHexagonLetters"];
    [location_queue length];
    

    
    
    
    NSArray *arr_loc=[location_queue componentsSeparatedByString:@" "];
    NSArray *arr_letter=[letter_queue componentsSeparatedByString:@" "];
    
    [[CCDirector sharedDirector]pause];
    
    int sum=(int)[arr_loc count];
    
    for (int i=0;i<sum;i++)
    {
        NSString *ee = [arr_loc objectAtIndex:i];
        NSString *le=[arr_letter objectAtIndex:i];
        CGPoint p=[ee NSStringToCGPoint];
        [self generateHexagonAtPosition:p withLetter:le];
        
    }
    
    [[CCDirector sharedDirector]resume];
}

@end
