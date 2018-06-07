//
//  IntroLayer.m
//  wordible
//
//  Created by callodiez on 08.07.2013.
//  Copyright tarzmedia 2013. All rights reserved.
//


// Import the interfaces
#import "WGThemeCore.h"
#import "WGSoundCore.h"

#import "IntroLayer.h"

#import "SoloGameLayer.h"
#import "DuoGameLayer.h"
#import "RulesLayer.h"

#import "GlobalDefines.h"
#import "GlobalEnums.h"

#import "CCBoardLayer.h"
#import "SimpleAudioEngine.h"

#import "CCMenuAdvanced.h"
#import "ScalableMenuItemImage.h"
#import "CCRadialMenu.h"

#import "DirectoryUtils.h"

#import "Medal.h"

#import "Reachability.h"
#import "KTInternetUtils.h"
#import "KTHardwareUtils.h"

#pragma mark - IntroLayer

// IntroLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the IntroLayer as the only child.
+(CCScene *) scene_
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
    [WGThemeCore reShuffleColorIndexes:NO];
	if( (self=[super initWithColor:[WGThemeCore getBackgroundColor]])) {
        //GEREKSİZ-SİL-orient_timeout_triggered=NO;
        [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postOrientationChanged) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
        
		// ask director for the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
		[self initBoard];
    }
	
	return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    if (alertView)
    {
        [alertView release];
    }
    
    [super dealloc];
}

-(void) onEnter
{
	[super onEnter];
    [self postOrientationChanged];
    
    BOOL a=[[WGSoundCore sharedDirector]getMusicMutedFromSettings];
    if (!a)
    {
        if(![[SimpleAudioEngine sharedEngine]isBackgroundMusicPlaying])
        {
            [AudioVisualization removeSharedAv];
            [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"2.mp3"];
            
        }
        [[AudioVisualization sharedAV] addDelegate:self forChannel:0];
    }
    
    
    //return; //!!!!!!!!!!!!!!!!
    
    [WGScoreCore standartScoreCore].delegate=self;
    
    BOOL isOfflineRegistered=[[WGScoreCore standartScoreCore]isOfflineRegistered];
    //if(isOfflineRegistered)
    //{
    //CCMenuAdvanced *menu_=(CCMenuAdvanced*)[self getChildByTag:TAG_INTRO_START_MENU_LAYER];
    //ScalableMenuItemImage *m3=(ScalableMenuItemImage*)[menu_ getChildByTag:TAG_INTRO_ONLINEAREA_MENUITEM];
    //[m3 setVisible:NO];
    //    [self scheduleOnce:@selector(doGetRankFromServer:) delay:0.5f];
    //}
    
    
    //BOOL isOfflineRegistered=NO;
    
    if(isOfflineRegistered)//A
    {
        
        if([[KTInternetUtils standartUtils]isOnline])//C
        {
            //[[WGScoreCore standartScoreCore]postRankToServer: TAG_URL_SENDRANK_ASHX];
            [self scheduleOnce:@selector(doPostRankToserver:) delay:0.5f];
        }
    }
    /*
     else
     {
     if([[KTInternetUtils standartUtils]isOnline])//B
     {
     //D
     [[WGScoreCore standartScoreCore]saveUserNameAndPasswordOffline:@"hasanhüseyin" password:@"123456"];
     [[WGScoreCore standartScoreCore] registerUserToServer:TAG_URL_REGISTERUSER_ASHX];
     
     //F
     [[WGScoreCore standartScoreCore]postRankToServer:TAG_URL_SENDRANK_ASHX];
     
     }
     else
     {
     //E
     CCMenuAdvanced *menu_=(CCMenuAdvanced*)[self getChildByTag:TAG_INTRO_START_MENU_LAYER];
     ScalableMenuItemImage *m3=(ScalableMenuItemImage*)[menu_ getChildByTag:TAG_INTRO_ONLINEAREA_MENUITEM];
     [m3 setVisible:NO];
     }
     }
     */
    
}

-(void)onExit
{
    [super onExit];
}

-(void)MyRemoveSprite:(CCSprite*)sender
{
    [sender removeFromParentAndCleanup:YES];
}

- (void) avAvgPowerLevelDidChange:(float) level channel:(ushort) theChannel
{
    if (level>1)return;
    
    static CGSize wsz;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wsz=[[CCDirector sharedDirector]winSize];
    });
    
    if(level>0.05f)
    {
        float k_=powf(level+1, 1.2);
        
        CCSprite *introFlakeSpr=[CCSprite spriteWithFile:@"6gen_introFlake.png"];
        [introFlakeSpr setOpacity:0];
        [introFlakeSpr runAction:[CCFadeOut actionWithDuration:0]];
        [introFlakeSpr setScale:k_];
        
        [self addChild:introFlakeSpr];
        [introFlakeSpr setZOrder:0];
        [self reorderChild:introFlakeSpr z:1];
        int x0_=arc4random() %((int)wsz.width);
        int y0_=arc4random() %((int)wsz.height);
        
        int x1_=(arc4random() %((int)wsz.width))*1.2;
        int y1_=(arc4random() %((int)wsz.height)*1.2);
        
        [introFlakeSpr setPosition:ccp(x0_,y0_)];
        static ccColor3B c=ccc3(0, 0, 0);
        static BOOL ever1=NO;
        if (!ever1 ||([WGThemeCore isForceToGetColors]))
        {
            c=[WGThemeCore getHexagonColor];
            ever1=YES;
            //[WGThemeCore setForceToGetColors:NO];
        }
        [introFlakeSpr setColor:c];
        
        id a1=[CCMoveTo actionWithDuration:k_/4.0f position:ccp(x1_,y1_)];
        //CCLOG(@"%f",k_);
        id a2=[CCFadeIn actionWithDuration:k_/8.0f];
        id a3=[CCFadeOut actionWithDuration:k_/8.0f];
        id f1=[CCCallFuncN actionWithTarget:self selector:@selector(MyRemoveSprite:)];
        id seq1=[CCSequence actions:a2,a3,f1,nil];
        //id r1=[CCRo]
        id e1=[CCEaseOut actionWithAction:a1 rate:2];
        id spw1=[CCSpawn actions:e1,seq1, nil];
        [introFlakeSpr runAction:spw1];
    }
}

-(void)postOrientationChanged
//    {
//-(void)orientationChanged:(NSNotification*)notification
{
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    
    //BOOL isKnownRotation=(orientation==UIDeviceOrientationPortrait)||(orientation==UIDeviceOrientationPortraitUpsideDown)||
    //(orientation==UIDeviceOrientationLandscapeLeft)||(orientation==UIDeviceOrientationLandscapeRight);
    
    //if(isKnownRotation)
    //{
    //[self setLastOrientation:orientation];
    [self rePositionBoard:orientation];
    //[self rotateLettersTo:orientation];
    //}
}

-(void)rePositionBoard:(UIDeviceOrientation)orientation
{
    //CGSize wsz=[[CCDirector sharedDirector]winSize];
    
    CCMenuAdvanced *menu_=(CCMenuAdvanced*)[self getChildByTag:TAG_INTRO_START_MENU_LAYER];
    //CGSize menu_sz_=[menu_ contentSize];
    
    //CCMenuAdvanced *socialMenu_=(CCMenuAdvanced*)[self getChildByTag:TAG_SOCIALBUTTONS_MENU_LAYER];
    //CGSize socialMenu_sz_=[socialMenu_ contentSize];
    
    //CGPoint loc_menu_,loc_socialMenu,loc_medal=ccp(0,0);
    
    float rotation_=0;
    
    CCSprite *medal=(CCSprite*)[self getChildByTag:TAG_MEDAL_SPRITE];
    //CGSize medal_sz_=medal.contentSize;
    
    BOOL isKnownRotation=(orientation==UIDeviceOrientationPortrait)||(orientation==UIDeviceOrientationPortraitUpsideDown)||
    (orientation==UIDeviceOrientationLandscapeLeft)||(orientation==UIDeviceOrientationLandscapeRight);
    if(!isKnownRotation)orientation=UIDeviceOrientationPortrait;
    
    
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            //loc_menu_=ccp(wsz.width/2-menu_sz_.width/2,wsz.height-(menu_sz_.height)-10);
            //loc_socialMenu=ccp(wsz.width/2-socialMenu_sz_.width/2,wsz.height-(socialMenu_sz_.height)-(menu_sz_.height));
            //loc_medal=ccp(wsz.width/2,medal_sz_.height);
            rotation_=0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            //loc_menu_=ccp(wsz.width/2-menu_sz_.width/2,10);
            //loc_socialMenu=ccp(wsz.width/2-socialMenu_sz_.width/2,menu_sz_.height);
            //loc_medal=ccp(wsz.width/2,wsz.height-medal_sz_.height);
            rotation_=180;
            break;
        case UIDeviceOrientationLandscapeLeft:
            //loc_menu_=ccp(wsz.width-(menu_sz_.width)-40,wsz.height/2-menu_sz_.height/2);
            //loc_socialMenu=ccp(wsz.width-(socialMenu_sz_.width)-(socialMenu_sz_.width/2),wsz.height/2-socialMenu_sz_.height/2);
            //loc_medal=ccp(wsz.width-medal_sz_.width+60,medal_sz_.height/2+20);
            rotation_=90;
            break;
        case UIDeviceOrientationLandscapeRight:
            //loc_menu_=ccp(+40,wsz.height/2-menu_sz_.height/2);
            //loc_socialMenu=ccp((socialMenu_sz_.width)-(socialMenu_sz_.width/2),wsz.height/2-socialMenu_sz_.height/2);
            //loc_medal=ccp(medal_sz_.width/2+20,wsz.height-(medal_sz_.height/2+20));
            rotation_=-90;
            break;
        default:
            break;
    }
    //loc_Score_=[[CCDirector sharedDirector]convertToGL:loc_Score_];
    //[menu_ setPosition:loc_menu_];
    //[menu_ setAnchorPoint:ccp(-0.5f,-0.5f)];
    //[menu_ runAction:[CCRotateTo actionWithDuration:5 angle:rotation_]];
    for (ScalableMenuItemImage *ee in menu_.children) {
        id a=[CCRotateTo actionWithDuration:1.0f angle:rotation_];
        id ea=[CCEaseElasticOut actionWithAction:a period:0.3f];
        [ee runAction:ea];
        
    }
    //[socialMenu_ setPosition:loc_socialMenu];
    //[socialMenu_ setRotation:rotation_];
    
    // [medal setRotation:rotation_];
    
    id a=[CCRotateTo actionWithDuration:1.0f angle:rotation_];
    id ea=[CCEaseElasticOut actionWithAction:a period:0.3f];
    [medal runAction:ea];
    //[medal setPosition:loc_medal];
    
    if (alertView)
    {
        [alertView setRotation:rotation_];
    }
}

//this is used only in initBoard. (to void repeating same codeblock)
-(void)addMenuLabels:(ScalableMenuItemImage*)parentmenu menuLabel:(NSString*)labelString
{
    CGSize csize=[parentmenu contentSize];
    
    CCLabelBMFont *lbl_m1=[CCLabelBMFont labelWithString:labelString fntFile:@"chalkbuster_30.fnt"];
    [lbl_m1 setColor:[WGThemeCore getHexagonFontColor]];
    [parentmenu setColor:[WGThemeCore getHexagonColor]];
    
    [parentmenu addChild:lbl_m1];
    [lbl_m1 setPosition:ccp(csize.width/2,csize.height/2)];
}

-(void)initBoard
{
    CGSize wsz=[[CCDirector sharedDirector]winSize];
    
    NSArray *menuItems = [NSArray arrayWithObjects:
                          [ScalableMenuItemImage itemWithNormalImage:@"buttonSolo.png" selectedImage:@"buttonSolo.png" target:self selector:@selector(buttonSoloGamePressed)],
                          [ScalableMenuItemImage itemWithNormalImage:@"buttonDuo.png" selectedImage:@"buttonDuo.png" target:self selector:@selector(buttonDuoGamePressed)],
                          [ScalableMenuItemImage itemWithNormalImage:@"buttonTheme.png" selectedImage:@"buttonTheme.png" target:self selector:@selector(buttonNextThemePressed)],
                          [ScalableMenuItemImage itemWithNormalImage:@"buttonOnlineArena.png" selectedImage:@"buttonOnlineArena.png" target:self selector:@selector(buttonOnlineArenaPressed)],
                          [ScalableMenuItemImage itemWithNormalImage:@"buttonSettings.png" selectedImage:@"buttonSettings.png" target:self selector:@selector(buttonSettingsPressed)],
                          [ScalableMenuItemImage itemWithNormalImage:@"buttonStartupGuide.png" selectedImage:@"buttonStartupGuide.png" target:self selector:@selector(buttonStartupGuidePressed)],
                          [ScalableMenuItemImage itemWithNormalImage:@"www.png" selectedImage:@"www.png" target:self selector:@selector(buttonWwwPressed)],
                          [ScalableMenuItemImage itemWithNormalImage:@"email.png" selectedImage:@"email.png" target:self selector:@selector(buttonEmailPressed)],
                          //[ScalableMenuItemImage itemWithNormalImage:@"facebook.png" selectedImage:@"facebook.png" target:self selector:@selector(buttonSoloGamePressed)],
                          [ScalableMenuItemImage itemWithNormalImage:@"like.png" selectedImage:@"like.png" target:self selector:@selector(buttonLikePressed)],
                          [ScalableMenuItemImage itemWithNormalImage:@"twitter.png" selectedImage:@"twitter.png" target:self selector:@selector(buttonTwitterPressed)],
                          //[ScalableMenuItemImage itemWithNormalImage:@"email.png" selectedImage:@"email.png" target:self selector:@selector(buttonEmailPressed)],
                          
                          nil];
    CCRadialMenu *menu = [CCRadialMenu radialMenuWithArray:menuItems radius:130.0f];
    [menu setTag:TAG_INTRO_START_MENU_LAYER];
    menu.position = ccp(wsz.width/2,wsz.height/2);
    [menu alignItemsRadially];
    [self addChild:menu];
    [menu setZOrder:3];
    [[Medal sharedMedal]initMedalto:self];
    
    CCLayer *tmp=(CCLayer*)[Medal sharedMedal].medalSprite;
    [[WGScoreCore standartScoreCore]displayScoresWithParent:tmp];

    bool isEverIntroLayerStartedUp=[[NSUserDefaults standardUserDefaults]boolForKey:@"isEverIntroLayerStartedUp"];
    
    if(!isEverIntroLayerStartedUp)
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isEverIntroLayerStartedUp"];
        [[NSUserDefaults standardUserDefaults]synchronize];

        id a1=[CCScaleTo actionWithDuration:.9f scale:1.3f];
        id a2=[CCScaleTo actionWithDuration:.6f scale:1.0f];
        id e1=[CCEaseElasticOut actionWithAction:a1 period:.3f];
        id e2=[CCEaseElasticOut actionWithAction:a2 period:.3f];
        
        id sa=[CCSequence actions:e1,e2, nil];
        id ra=[CCRepeat actionWithAction:sa times:8];
        
        ScalableMenuItemImage *soloBtn=(ScalableMenuItemImage*)[[menu children]objectAtIndex:0];
        [soloBtn runAction:ra];
        
        return;
    }


}
#pragma mark - button Methods
-(void)buttonSettingsPressed
{
    id layerClass_= NSClassFromString(@"SettingsLayer");
    [[CCDirector sharedDirector]replaceScene:[CCTransitionSlideInL transitionWithDuration:1 scene:[layerClass_ scene_]]];
    
}

-(void)buttonOnlineArenaPressed
{
    //BOOL a=[[WGScoreCore standartScoreCore]isOfflineRegistered];
    //BOOL b=[[KTInternetUtils standartUtils]isOnline];
    
   // if ((!a) && b)//daha önce offline kayıt olmamış ve internet açıksa join olsun
   // {
        //NSString *userName=[[NSUserDefaults standardUserDefaults]stringForKey:@"onlineArenaUserName"];
        id layerClass_= NSClassFromString(@"AvatarLayer");
        [[CCDirector sharedDirector]replaceScene:[CCTransitionSlideInL transitionWithDuration:1 scene:[layerClass_ scene_]]];
    //}
}

-(void)buttonNextThemePressed
{
    [WGThemeCore setNextSelectedTheme];
    [WGThemeCore setForceToGetColors:YES];
    [[CCDirector sharedDirector]replaceScene:[CCTransitionFade transitionWithDuration:1 scene:[IntroLayer scene_] withColor:[WGThemeCore getHexagonColor]]];
}



-(void)buttonSoloGamePressed
{
    [WGThemeCore setForceToGetColors:YES];
    /*
    NSString *letter_queue=[[NSUserDefaults standardUserDefaults]objectForKey:@"soloGameHexagonLetters"];
    int letter_len_=[letter_queue length];
    
    if (letter_len_>0)
    {
        if (alertView)
        {
            [alertView release];
            alertView=nil;
        }
        
        alertView = [[CCAlertView alloc] initWithTitle:@"CONTINUE ?" message:@"Continue Previous Game ?" delegate:self cancelButtonTitle:@"CONTINUE" otherButtonTitle:@"NEW GAME"];
        UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
        [self rePositionBoard:orientation];
        [alertView setTag:1];//1 ise solo 2 ise duo indexSelected için ayırtedici özellik olarak kullanılıyor.
        [alertView showAV];
        
    }
    else
     */
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:1.0 scene:[SoloGameLayer scene_]]];
}

/*
//CCAlertView delegate i
- (void) CCAlertView:(CCLayer*)sender indexSelected:(int)index {
    
    if ([sender tag]==1)
    {
        switch (index) {
            case 1:// ise NEW GAME olduğundan savestate i sil.
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"soloGameHexagonStates"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"soloGameHexagonLetters"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"soloGameTotalScore"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [WGThemeCore deletePoppedWordsplist];
                [WGThemeCore resetRankandSyncronize:YES];
            default:
                break;
        }
        
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:1.0 scene:[SoloGameLayer scene]]];
    }
    
    else if ([sender tag]==2)
    {
        switch (index) {
            case 1:// ise NEW GAME olduğundan savestate i sil.
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"duoGameHexagonStates"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"duoGameHexagonLetters"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"duoGameTotalScoreP1"];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"duoGameTotalScoreP2"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [WGThemeCore deletePoppedWordsplist];
                [WGThemeCore resetRankandSyncronize:YES];
            default:
                break;
        }
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:1.0 scene:[DuoGameLayer scene]]];
    }
}
*/


-(void)buttonDuoGamePressed
{
    [WGThemeCore setForceToGetColors:YES];
    /*
    NSString *letter_queue=[[NSUserDefaults standardUserDefaults]objectForKey:@"duoGameHexagonLetters"];
    int letter_len_=[letter_queue length];
    
    if (letter_len_>0)
    {
        if (alertView)
        {
            [alertView release];
            alertView=nil;
        }
        
        alertView = [[CCAlertView alloc] initWithTitle:@"CONTINUE ?" message:@"Continue Previous Game ?" delegate:self cancelButtonTitle:@"CONTINUE" otherButtonTitle:@"NEW GAME"];
        UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
        [self rePositionBoard:orientation];
        [alertView setTag:2];//1 ise solo 2 ise duo indexSelected için ayırtedici özellik olarak kullanılıyor.
        [alertView showAV];
        
    }
    else
     */
        [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:1.0 scene:[DuoGameLayer scene_]]];
    
}


-(void)buttonStartupGuidePressed
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionSlideInR transitionWithDuration:1.0 scene:[RulesLayer scene_]]];
}

-(void)buttonWwwPressed
{
    NSURL *url=[NSURL URLWithString:@"http://wordigoo.com"];
    [[UIApplication sharedApplication]openURL:url];
}

-(void)buttonTwitterPressed
{
    NSURL *url=[NSURL URLWithString:@"http://twitter.com/wordigoo"];
    [[UIApplication sharedApplication]openURL:url];
}
/*
 -(void)buttonFacebookPressed
 {
 NSURL *url=[NSURL URLWithString:@"http://facebook.com/wordigoo"];
 [[UIApplication sharedApplication]openURL:url];
 }
 */
-(void)buttonLikePressed
{
    NSString *myAppID=([KTHardwareUtils isIPad])?@"672909247":@"688769294";
    
    NSString* url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", myAppID];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
}
-(void)buttonEmailPressed
{
    NSURL *url=[NSURL URLWithString:@"http://fablesalive.com/Pages/FooterForm.aspx?ID=6"];
    [[UIApplication sharedApplication]openURL:url];
}

#pragma mark - Online / Offline Rank methods
-(void)WGDidFinishLoading:(WGScoreCore*)sender asyncResultType:(WGScoreCoreAsyncResultType)aasyncresulttype Success:(BOOL)asuccess data:(NSData*)adata
{
    // NSLog(@"WGDidFinishLoading :%@",((asuccess==YES)?@"YES":@"NO"));
    NSString *infoText=nil;
    
    if (asuccess==NO)
    {
        switch (aasyncresulttype)
        {
            case arForGetRank:
                infoText=@"Error: could not get ranks from server";
                break;
            case arForNone:
                infoText=@"Error: arForNone";
                break;
            case arForIsRegisteredBefore:
                infoText=@"Error: could not get registered before";
                break;
            case arForPostRank:
                infoText=@"Error: could not post rank to server";
                break;
            case arForRegisterUser:
                infoText=@"Error: could not register user to server";
                break;
                
            default:
                break;
        }//end of switch-
    }//end of if-
    else
    {
        switch (aasyncresulttype)
        {
            case arForGetRank:
            {
                infoText=@"Success: get ranks from server";
                [[WGScoreCore standartScoreCore]saveRanksData:adata];
                
                CCLayer *tmp=(CCLayer*)[Medal sharedMedal].medalSprite;
                [[WGScoreCore standartScoreCore]displayScoresWithParent:tmp];
                break;
            }
                
            case arForNone:
                infoText=@"Success: for unknown";
                break;
            case arForIsRegisteredBefore:
                infoText=@"Success: get ranks from server";
                break;
            case arForPostRank:
                infoText=@"Success: post ranks from server";
                [self scheduleOnce:@selector(doGetRankFromServer:) delay:0.5f];
                break;
            case arForRegisterUser:
                infoText=@"Success: get ranks from server";
                //[self scheduleOnce:@selector(doGetRankFromServer:) delay:0.5f];
                break;
            default:
                break;
        }//-end of switch-
    }//-end of else-
    // [self setErrorLabel:infoText];
}

-(void)doGetRankFromServer:(NSTimer*)sender
{
    [[WGScoreCore standartScoreCore]getRankFromServer:TAG_URL_GETRANK_ASHX];
}
-(void)doPostRankToserver:(NSTimer*)sender
{
    [[WGScoreCore standartScoreCore]postRankToServer:TAG_URL_SENDRANK_ASHX];
}

@end
