//
//  JoinOnlineLayer.m
//  wordigoo-iphone
//
//  Created by callodiez on 01.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "JoinOnlineLayer.h"
#import "CCTextField.h"
#import "CCControlExtension.h"
#import "WGScoreCore.h"
#import "WGThemeCore.h"
#import "GlobalDefines.h"
#import "CCNode+Utilities.h"
#import "CCControlButton+Utilities.h"
#import "Medal.h"

@implementation JoinOnlineLayer

+(CCScene*)scene_
{
    CCScene *scene=[CCScene node];
    JoinOnlineLayer *layer=[JoinOnlineLayer node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if(self=[super initWithColor:[WGThemeCore getBackgroundColor]])
    {
        [WGScoreCore standartScoreCore].delegate=self;
        [self initPlatform];
    }
    return self;
}

-(void)WGDidFinishLoading:(WGScoreCore*)sender asyncResultType:(WGScoreCoreAsyncResultType)aasyncresulttype Success:(BOOL)asuccess data:(NSData*)adata
{
    NSString *infoText=nil;
    NSString *strData=[[NSString alloc]initWithData:adata encoding:NSUTF8StringEncoding];
    
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
                [[WGScoreCore standartScoreCore]deleteUserNameAndPasswordOffline];
                break;
            case arForPostRank:
                infoText=@"Error: could not post rank to server";
                break;
            case arForRegisterUser:
                infoText=@"Error: could not register user to server";
                [[WGScoreCore standartScoreCore]deleteUserNameAndPasswordOffline];
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
                infoText=@"Success: get ranks from server";
                [[WGScoreCore standartScoreCore]saveRanksData:adata];
                //eğer kullanıcı doğru kullanıcı adı ve şifre girmişse rankların offline kaydında son puanınıda alıp kaydet.
                //[[WGScoreCore standartScoreCore]getUserLastPoint];
                NSUInteger score_=[[WGScoreCore standartScoreCore]getScoreOffline];
                [[Medal sharedMedal]checkandUpgradeLevelSignetByPoint:score_];
                
                id class1=NSClassFromString(@"IntroLayer");
                [[[CCDirector sharedDirector]view]endEditing:YES];
                [[CCDirector sharedDirector]replaceScene:[CCTransitionMoveInL transitionWithDuration:1 scene:[class1 scene_]]];
                break;
                
            case arForNone:
                infoText=@"Success: for unknown";
                break;
                
            case arForIsRegisteredBefore:
                
                if([strData isEqualToString:@"YES"])
                {
                    infoText=@"Success: get isregisteredbefore from server is YES";
                    //[self scheduleOnce:@selector(doRegisterUserToServer:) delay:0.5f];
                    [self scheduleOnce:@selector(doGetRankFromServer:) delay:0.5f];
                }
                else if([strData isEqualToString:@"NO"])
                {
                    infoText=@"Success: But get isregisteredbefore from server is NO";
                    //[[WGScoreCore standartScoreCore]deleteUserNameAndPasswordOffline];
                    [self scheduleOnce:@selector(doRegisterUserToServer:) delay:0.5f];
                }
                else
                {
                    infoText=[NSString stringWithFormat:@"Success: But get isregisteredbefore from server is UNKNOWN:%@",strData];
                }
                break;
                
            case arForPostRank:
                
                break;
            case arForRegisterUser:
                if([strData isEqualToString:@"YES"])
                {
                    infoText=@"Success: registeruser to server";
                    [self scheduleOnce:@selector(doGetRankFromServer:) delay:0.5f];
                }
                else if([strData isEqualToString:@"NO"])
                {
                    infoText=@"Success: registeruser to server:but returned NO.possible dublicated username or you forgot old password";
                    [[WGScoreCore standartScoreCore]deleteUserNameAndPasswordOffline];
                }
                break;
                
            default:
                break;
        }//-end of switch-
    }//-end of else-
    [self setErrorLabel:infoText];
    NSLog(@"%@",infoText);
}

-(void)doRegisterUserToServer:(NSTimer*)sender
{
    [[WGScoreCore standartScoreCore]registerUserToServer:TAG_URL_REGISTERUSER_ASHX];
}

-(void)doGetRankFromServer:(NSTimer*)sender
{
    [[WGScoreCore standartScoreCore]getRankFromServer:TAG_URL_GETRANK_ASHX];
    
}
-(void)initPlatform
{
    //
    BOOL a=([[WGScoreCore standartScoreCore]isOfflineRegistered]);
    
    if(a)
    {
        // NSString *username_=[]
        //  [WGScoreCore standartScoreCore]saveUserNameAndPasswordOffline:<#(NSString *)#> password:<#(NSString *)#>];
    }
    else
    {
        CGSize wsz=[[CCDirector sharedDirector]winSize];
        
        // LABEL WITH TEXTFIELD--------------------
        CCLayer *layer1=[[CCLayer alloc]init];
        [layer1 setContentSize:wsz];
        
        CCLabelBMFont *lbl1_=[CCLabelBMFont labelWithString:@"ENTER YOUR NAME" fntFile:@"chalkbuster_30.fnt"];
        [layer1 addChild:lbl1_];
        [lbl1_ setPosition:ccp(wsz.width/2, wsz.height-lbl1_.contentSize.height)];
        
        CCTextField *tf1=[CCTextField textFieldWithFieldSize:CGSizeMake(lbl1_.contentSize.width,lbl1_.contentSize.height+10) fontName:@"Helvetica" andFontSize:18];
        [tf1 setTag:TAG_JOINONLINE_USERNAME_CCTEXTFIELD];
        [tf1 setContentSize:CGSizeMake(tf1.contentSize.width, tf1.contentSize.height+10)];
        [layer1 addChild:tf1];
        [tf1 setMaxLength:12];
        [tf1 setPosition:ccp(lbl1_.position.x-lbl1_.contentSize.width/2,lbl1_.position.y-(lbl1_.contentSize.height*2)-2)];
        CCSprite *spr1=[CCSprite spriteWithFile:@"textFieldBg.png"];
        [layer1 addChild:spr1];
        [spr1 setPosition:ccp(wsz.width/2,wsz.height-40)];
        //END OF LABEL WITH TEXTFIELD--------------
        
        //LABEL WITH TEXTFIELD---------------------
        CCLabelBMFont *lbl2_=[CCLabelBMFont labelWithString:@"ENTER YOUR PASSWORD" fntFile:@"chalkbuster_30.fnt"];
        [self addChild:lbl2_];
        [lbl2_ setPosition:ccp(wsz.width/2, tf1.position.y-20)];
        CCTextField *tf2=[CCTextField textFieldWithFieldSize:CGSizeMake(lbl1_.contentSize.width,lbl1_.contentSize.height+10) fontName:@"Helvetica" andFontSize:18];
        [tf2 setTag:TAG_JOINONLINE_PASSWORD_CCTEXTFIELD];
        [tf2 setContentSize:CGSizeMake(tf2.contentSize.width, tf2.contentSize.height+10)];
        [layer1 addChild:tf2];
        [tf2 setMaxLength:12];
        [tf2 setPosition:ccp(tf1.position.x,lbl2_.position.y-(lbl2_.contentSize.height*2))];
        CCSprite *spr2=[CCSprite spriteWithFile:@"textFieldBg.png"];
        [layer1 addChild:spr2];
        [spr2 setPosition:ccp(wsz.width/2,wsz.height-100)];
        //END OF LABEL WITH TEXTFIELD---------------------
        
        CCControlButton *btn1 = [CCControlButton standardButtonWithTitle:@"LOGIN/SIGN UP" andFontSize:22];
        [btn1 addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:CCControlEventTouchUpInside];
        [btn1 setTag:1];
        [layer1 addChild:btn1];
        CCControlButton *btn2 = [CCControlButton standardButtonWithTitle:@"CANCEL" andFontSize:22];
        [btn2 setTag:2];
        [btn2 addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:CCControlEventTouchUpInside];
        [layer1 addChild:btn2];
        
        [btn1 setPosition:ccp(wsz.width/2,tf2.position.y-20)];
        [btn2 setPosition:ccp(wsz.width/2,tf2.position.y-50)];
        [self addChild:layer1];
        [tf1 setZOrder:3];
        [tf2 setZOrder:3];
        
        [self setErrorLabel:@"Important: Note your username and password. Typing a new non-existent username creates a new account with zero points. If you are a new user, you must take note somewhere your username/password. There is no restore password functionality."];

        //END OF LAYER 2
    }//end of else-
}

- (void)touchUpInsideAction:(CCControlButton *)sender
{
    //NSLog(@"Touch Up Inside.");
    [self clearErrorLabel];
    id class1=NSClassFromString(@"IntroLayer");
    
    CCTextField *tfUser=(CCTextField*)[self getChildByTagRecursive:TAG_JOINONLINE_USERNAME_CCTEXTFIELD];
    CCTextField *tfPass=(CCTextField*)[self getChildByTagRecursive:TAG_JOINONLINE_PASSWORD_CCTEXTFIELD];
    
    NSString *user=[[tfUser textField]text];
    user=[user stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *pass=[[tfPass textField]text];
    pass=[pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    BOOL b=(([user length]>3)&&([pass length]>5));
    //NSString *vendor=[[WGScoreCore standartScoreCore]getIdentifierForVendor];
    
    //BOOL a=NO;
    NSLog(@"%@ %@",user,pass);
    switch (sender.tag) {
        case 1://join/signup button
            
            if(!b)
            {
                [self setErrorLabel:@"minimum user name length:4 password length:6"];
                return;
            }
            [[WGScoreCore standartScoreCore]saveUserNameAndPasswordOffline:user password:pass];
            
            //(alttaki kod)isonlineregistered geri verigelmiş ise doRegisterUserToServer çalıştırılıyor scheduledonce ile
            [[WGScoreCore standartScoreCore]getIsOnlineRegistered:TAG_URL_ISONLINEREGISTERED_ASHX];
            
            //[[WGScoreCore standartScoreCore]registerUserToServer:TAG_URL_REGISTERUSER_ASHX];
            break;
        case 2://cancel button
            
            //[[WGScoreCore standartScoreCore]getRankFromServer:TAG_URL_GETRANK_ASHX];
            //return;
            
            [[[CCDirector sharedDirector]view]endEditing:YES];
            [[CCDirector sharedDirector]replaceScene:[CCTransitionMoveInL transitionWithDuration:1 scene:[class1 scene_]]];
            break;
            
        default:
            break;
    }
}



-(void)setErrorLabel:(NSString*)aerrortext
{
    [self clearErrorLabel];
    CGSize wsz=[[CCDirector sharedDirector]winSize];
    CCLabelBMFont *errLabel=(CCLabelBMFont*)[self getChildByTagRecursive:TAG_JOINONLINE_ERROR_LABEL];
    
    if(!errLabel)
    {
        errLabel=[CCLabelBMFont labelWithString:aerrortext fntFile:@"chalkbuster_30.fnt" width:wsz.width alignment:kCCTextAlignmentCenter];
        [errLabel setTag:TAG_JOINONLINE_ERROR_LABEL];
        [errLabel setAnchorPoint:ccp(0.5f,1.0f)];
        [errLabel setPosition:ccp(wsz.width/2,290)];
        [self addChild:errLabel];
        [errLabel setZOrder:1];
    }
    [errLabel setString:aerrortext];
}

-(void)clearErrorLabel
{
    CCLabelBMFont *errLabel=(CCLabelBMFont*)[self getChildByTagRecursive:TAG_JOINONLINE_ERROR_LABEL];
    if(errLabel)
    {
        [errLabel setString:@""];
        [errLabel cleanup];
    }
}

@end
