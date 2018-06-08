//
//  AvatarLayer.m
//  wordigoo-iphone
//
//  Created by Kursat Turkay on 15.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "AvatarLayer.h"
#import "CCControlButton+Utilities.h"
#import "WGThemeCore.h"
#import "WGScoreCore.h"
#import "KTInternetUtils.h"
#import "HJMaskedSprite.h"

@implementation AvatarLayer
@synthesize img,photoSprite;

-(id)init
{
    if(self=[super initWithColor:[WGThemeCore getBackgroundColor]])
    {
        [self initPlatform];
        //pickerController=[[UIImagePickerController alloc]init];
        //[pickerController setAllowsEditing:YES];
        // [pickerController setDelegate:self];
    }
    return self;
}

-(void)dealloc
{
    //[pickerController release];
    [super dealloc];
}

-(void)onEnter
{
    [super onEnter];
    [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
}

+(CCScene*)scene_
{
    CCScene *scene= [CCScene node];
    AvatarLayer *avatarLayer=[AvatarLayer node];
    [scene addChild:avatarLayer];
    return scene;
}

-(void)initPlatform
{
    CGSize wsz=[[CCDirector sharedDirector]winSize];
    
    CCSprite *circleSpr=[CCSprite spriteWithFile:@"photoCircle.png"];
    [circleSpr setTag:779];
    
    [self addChild:circleSpr];
    [circleSpr setPosition:ccp(wsz.width/2,wsz.height/2)];
    [circleSpr setZOrder:3];
    
    CCControlButton *btnNext=[CCControlButton standardButtonWithTitle:@"NEXT >" andFontSize:18];
    [btnNext addTarget:self action:@selector(btnNextPressed:) forControlEvents:CCControlEventTouchUpInside];
    [self addChild: btnNext];
    [btnNext setZOrder:4];
    [btnNext setPosition:ccp(wsz.width/2,btnNext.contentSize.height)];
    
    CCControlButton *btntakePhotoAgain=[CCControlButton standardButtonWithTitle:@"TAKE PHOTO AGAIN" andFontSize:18];
    [btntakePhotoAgain addTarget:self action:@selector(btnTakePhotoAgainPressed:) forControlEvents:CCControlEventTouchUpInside];
    [self addChild:btntakePhotoAgain];
    [btntakePhotoAgain setZOrder:4];
    [btntakePhotoAgain setPosition:ccp(wsz.width/2,btntakePhotoAgain.contentSize.height+btntakePhotoAgain.contentSize.height)];
    
}
-(void)btnTakePhotoAgainPressed:(CCControlButton*)sender
{
    [self pickPhoto:UIImagePickerControllerSourceTypeCamera];
}

-(void)btnNextPressed:(CCControlButton*)sender
{
    CGSize wsz=[[CCDirector sharedDirector]winSize];
    
    CCRenderTexture *renderTexture=[CCRenderTexture renderTextureWithWidth:256 height:256];
    [renderTexture setZOrder:5];
    [self addChild:renderTexture];

    [renderTexture setAnchorPoint:CGPointMake(0.5f, 0.5f)];
    [renderTexture setPosition:ccp((wsz.width/2),(wsz.height/2))];

    [renderTexture begin];
    [self.photoSprite visit];
    [renderTexture end];
    [renderTexture saveToFile:@"tmp.png" format:kCCImageFormatPNG];
    
    //CCTexture2D *tmpTexture=[CCTexture2D alloc]initWith CGImage:self.photoSprite. resolutionType:<#(ccResolutionType)#>;
    //CCSprite *squareSprite=(CCSprite spriteWithTexture:<#(CCTexture2D *)#> rect:<#(CGRect)#>);
/*

    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    CCRenderTexture *rendertxt= [CCRenderTexture renderTextureWithWidth:self.photoSprite.contentSize.width height:self.photoSprite.contentSize.height];
    [rendertxt setZOrder:5];
    [rendertxt setPosition:ccp(wsz.width/2,wsz.height/2)];
    
    [rendertxt begin];
    [self.photoSprite visit];
    [rendertxt end];
    
    NSArray *documents=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath=[documents objectAtIndex:0];
    NSString *fn=[docPath stringByAppendingPathComponent:@"tmp1.png"];
    //[self addChild:rendertxt];
    BOOL a=[rendertxt saveToFile:@"tmp1.png" format:kCCImageFormatPNG];
    
    HJMaskedSprite *demoSpr=[[HJMaskedSprite alloc]initWithFile:@"photoCircleMask.png" andImageOverlay:fn];
    
    [self removeChild:self.photoSprite cleanup:YES];
    CCSprite *circleSprite=(CCSprite*)[self getChildByTag:779];
    [self removeChild:circleSprite cleanup:YES];
    [demoSpr setZOrder:5];
    [self addChild:demoSpr];
    [demoSpr setPosition:ccp(wsz.width/2,wsz.height/2)];
 
    BOOL a=[[WGScoreCore standartScoreCore]isOfflineRegistered];
    BOOL b=[[KTInternetUtils standartUtils]isOnline];
    
    if ((!a) && b)//daha önce offline kayıt olmamış ve internet açıksa join olsun
    {
        //NSString *userName=[[NSUserDefaults standardUserDefaults]stringForKey:@"onlineArenaUserName"];
        id layerClass_= NSClassFromString(@"JoinOnlineLayer");
        [[CCDirector sharedDirector]replaceScene:[CCTransitionSlideInL transitionWithDuration:1 scene:[layerClass_ scene]]];
    }
     */
    
}
-(void)pickPhoto:(UIImagePickerControllerSourceType)asourcetype
{
    UIViewController *tempvc=[[UIViewController alloc]init];
    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    picker.sourceType=asourcetype;
    picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;
    picker.wantsFullScreenLayout=YES;
    [[[CCDirector sharedDirector]view]addSubview:[tempvc view]];
    //[tempvc presentViewController:tempvc animated:YES completion:^{}];
    [tempvc presentModalViewController:picker animated:YES];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.img=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker.view removeFromSuperview];
    [picker release];
    [self unfoldImage];
}
-(void)unfoldImage
{
    CGSize wsz=[[CCDirector sharedDirector]winSize];
    CCTexture2D *txt1=[[CCTexture2D alloc]initWithCGImage:self.img.CGImage resolutionType:kCCResolutionUnknown];
    if(self.photoSprite)
    {
        [self removeChild:self.photoSprite cleanup:YES];
        //[self.photoSprite release];
        //self.photoSprite=nil;
    }
    
    self.photoSprite=[PhotoSprite spriteWithTexture:txt1];
    [self.photoSprite setScale: 2.0f];
    [self.photoSprite setZOrder:2];
    [self addChild:self.photoSprite];
    [self.photoSprite setPosition:ccp(wsz.width/2,wsz.height/2)];
    [self.photoSprite setRotation:90.0f];
}

@end
