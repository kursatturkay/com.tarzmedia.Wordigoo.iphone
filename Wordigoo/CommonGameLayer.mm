//
//  CommonGameLayer.m
//  wordigoo
//
//  Created by callodiez on 16.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "cocos2d.h"

#import "CommonGameLayer.h"

#import "GlobalDefines.h"
#import "GeneralUtilities.h"

#import "WGSoundCore.h"
#import "KTHardwareUtils.h"

#import "CCMenuAdvanced.h"
#import "WGThemeCore.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@implementation CommonGameLayer
@synthesize lastFoundWord,world,cupSprite,nothingTouched,isCloneMode,cloneSprite,isBombMode,bombSprite,isBombTriggered,isWorldStepPaused,swapTimer;

#pragma mark letter and hexagon methods
-(id)initWithColor:(ccColor4B)color
{
    if(self=[super initWithColor:color])
    {
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"hex0.mp3"];
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"hex1.mp3"];
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"hexFound.mp3"];
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"dundin.mp3"];
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"hex1.mp3"];
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"hexFound.mp3"];
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"dundin.mp3"];
        isWorldStepPaused=NO;
    }
    return self;
    
}

-(void)onEnter
{
    [super onEnter];
    
    //if([[SimpleAudioEngine sharedEngine]isBackgroundMusicPlaying])
    //    [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
    
    
}

+(void)playNextMusic
{
    BOOL a=[[WGSoundCore sharedDirector]getMusicMutedFromSettings];
    if (a)return;
    
    static int counter_=0;
    //int music_no_=randIntBetween(0, 8);
    counter_=(counter_+1)%9;
    
    
    NSString *music_file_=[NSString stringWithFormat:@"%d.mp3",counter_];
    CCLOG(@"%d",counter_);
    if (counter_!=0)
        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:music_file_];
    else
        [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
}


//müziğe göre değişim efekti uygular.
-(void)effectHexagonsWave:(float)level
{
    //int x=world->GetBodyCount();
    b2Body *body=world->GetBodyList();
    for(int i=3;i!=victim_hexagon;i++)
    {
        if (body)
            body=body->GetNext();
    }
    if (!body)return;
    
    //NSAssert((!body),@"body is null error");
    //CCLOG(@"%d",victim_hexagon_);
    //return;
    GHSpriteHexagon *hx1_=(GHSpriteHexagon*)body->GetUserData();
    if([hx1_ tag]==1)return;
    
    [hx1_ setTag:1];
    
    //id a1=[CCFadeTo actionWithDuration:1 opacity:0];
    //id a2=[CCFadeIn actionWithDuration:1];
    int k_=level*100;//0.1 0.2 0.01 = 10 20 1
    
    //int setNegative=arc4random()%2;
    //if(setNegative==1)k_*=-1;
    
    static ccColor3B c_=ccc3(0,0,0);
    
    static BOOL ever1=NO;
    if (!ever1 ||([WGThemeCore isForceToGetColors]))
    {
        c_=[WGThemeCore getHexagonColor];//!!NEGATIVE - r eksi 42 olmaması lazım ama oluyo burda darkmorning de
        ever1=YES;
        [WGThemeCore setForceToGetColors:NO];
    }
    
    id a1=[CCTintTo actionWithDuration:1 red:c_.r-k_ green:c_.g-k_ blue:c_.b-k_];
    id a2=[CCTintTo actionWithDuration:1 red:c_.r green:c_.g blue:c_.b];
    id f1=[CCCallFuncN actionWithTarget:self selector:@selector(isHexagonActionStopped:)];
    id seq1=[CCSequence actions:a1,a2,f1, nil];
    
    //eğer dünya swap 2 hexagon dan dolayı durmuşsa stopAllactions olmasın çünkü ikisi yer değiştiriyor.
    if (![self isWorldStepPaused])
        [hx1_ stopAllActions];
    
    [hx1_ runAction:seq1];
}

//müzik dalgalanmasında blokların tagı 0 ise efekti bitmiştir.bunun için kullanıldı.
//SoloGameLayer ve DuoGameLayer kullanıyor.
-(void)isHexagonActionStopped:(GHSpriteHexagon*)sender
{
    [sender setTag:0];
}


-(BOOL)isAllHexagonsStopped
{
    BOOL ret_=YES;
    
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext())
    {
        if (b->GetUserData() != NULL)
        {
            if(!(b->IsAwake()))
            {
                // body is moving
                ret_=NO;
            }
            
            // or
            /*
             b2Vec2 velocity = b->GetLinearVelocity();
             if(velocity.x == 0 && velocity.y == 0)
             {
             // body is not moving
             }
             */
        }
        //ret_= NO;
    }
    return ret_;
}

-(BOOL)isHexagonSameLastSelectedHexagon:(GHSpriteHexagon*)aHexagon
{
    GHSpriteHexagon *hxLast=(GHSpriteHexagon*)[[GHSpriteHexagon selectedHexagons]lastObject];
    return [aHexagon isEqual:hxLast];
}

-(BOOL)isHexagonNearLastSelectedHexagon:(GHSpriteHexagon*)aHexagon
{
    BOOL ret_=NO;
    
    int c1=[[GHSpriteHexagon selectedHexagons]count];
    if (c1==0) return YES;
    
    GHSpriteHexagon *hxLast=
    [[GHSpriteHexagon selectedHexagons]lastObject];
    
    if (!hxLast)return NO;
    
    
    b2Body *p1_b=[hxLast bodybody];
    b2Transform p1_t=p1_b->GetTransform();
    
    b2Body *p2_b=[aHexagon bodybody];
    b2Transform p2_t=p2_b->GetTransform();
    
    CGPoint p1=ccp(p1_t.p.x*PTM_RATIO,p1_t.p.y*PTM_RATIO);
    CGPoint p2=ccp(p2_t.p.x*PTM_RATIO,p2_t.p.y*PTM_RATIO);
    
    CGFloat L1= ccpDistance(p1,p2);
    
    ret_= (L1<60);
    //CCLOG(@"isHexagonNearLastSelectedHexagon:%f|hxLast.letter:%@|aHexagon.letter:%@",L1,[hxLast letter],[aHexagon letter]);
    return ret_;
}

-(CGFloat)getRotateByOrientation:(UIDeviceOrientation)orientation
{
    float deg_=0;
    
    switch (orientation){
        case UIDeviceOrientationLandscapeLeft:
            deg_=90;
            break;
        case UIDeviceOrientationLandscapeRight:
            deg_=-90;
            break;
        case UIDeviceOrientationPortrait:
            deg_=0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            deg_=180;
            break;
        default:
            deg_=0;
            break;
    }
    return deg_;
}


-(void)rotateLettersTo:(UIDeviceOrientation)orientation
{
    for (b2Body *b=world->GetBodyList();b;b=b->GetNext())
    {
        GHSpriteHexagon *hx_=(GHSpriteHexagon*)b->GetUserData();
        NSString *cls_=NSStringFromClass([hx_ class]);
        if (![cls_ isEqualToString:@"GHSpriteHexagon"])return;
        
        float deg_=0;
        
        switch (orientation) {
            case UIDeviceOrientationLandscapeLeft:
                deg_=90;
                break;
            case UIDeviceOrientationLandscapeRight:
                deg_=-90;
                break;
            case UIDeviceOrientationPortrait:
                deg_=0;
                break;
            case UIDeviceOrientationPortraitUpsideDown:
                deg_=180;
                break;
            default:
                break;
        }
        
        CCLabelBMFont *cclabel_=(CCLabelBMFont*)[[hx_ children]objectAtIndex:0];
        id a1=[CCRotateTo actionWithDuration:.2 angle:deg_];
        //id e1=[CCEaseSineInOut  actionWithAction:a1];
        [cclabel_ runAction:a1];
    }
}


//harfleri cihazın duruşuna göre çevirir
-(void)rotateHexagonLetterToNormal:(GHSpriteHexagon*)hx
{
    //UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    
    float deg_=0;
    
    switch ([self lastOrientation]) {
        case UIDeviceOrientationLandscapeLeft:
            deg_=90;
            break;
        case UIDeviceOrientationLandscapeRight:
            deg_=-90;
            break;
        case UIDeviceOrientationPortrait:
            deg_=0;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            deg_=180;
            break;
        default:
            break;
    }
    
    CCLabelBMFont *cclabel_=(CCLabelBMFont*)[[hx children]objectAtIndex:0];
    NSAssert(cclabel_, @"Hexagon's Label is NULL");
    if (!cclabel_)return;
    
    id a1=[CCRotateTo actionWithDuration:.2 angle:deg_];
    
    //id e1=[CCEaseSineInOut  actionWithAction:a1];
    [cclabel_ runAction:a1];
}

//ekranın dikey çizgisi rotasyonuna göre  cgpoint dik ekseni hesaplar
-(CGPoint)getAxisYPositionWithPlus:(CGPoint)point WithPlus:(int)withplus
{
    CGPoint ret_=point;
    
    switch ([self lastOrientation]){
        case UIDeviceOrientationLandscapeLeft:
            ret_=ccp(ret_.x+withplus,ret_.y);
            break;
        case UIDeviceOrientationLandscapeRight:
            ret_=ccp(ret_.x-withplus,ret_.y);
            break;
        case UIDeviceOrientationPortrait:
            ret_=ccp(ret_.x,ret_.y+withplus);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            ret_=ccp(ret_.x,ret_.y-withplus);
            break;
        default:
            break;
    }
    return ret_;
}

//gets highlighted word lambs in a sequence.by other mean:dragged letters as a word
-(NSString*)getSelectedWord:(BOOL)lowerCased
{
    NSString *word_=[NSString string];
    
    for (GHSpriteHexagon *ee in [GHSpriteHexagon selectedHexagons]) {
        word_=[word_ stringByAppendingString:ee.letter];
    }
    
    if (lowerCased)
        word_=[word_ lowercaseString];
    return word_;
}


//seçim küpleri geriye doğrumu seçiliyor.bulmak için kullanılır.
-(BOOL)isHexagonPreviousHexagon:(GHSpriteHexagon*)aHexagon
{
    int t1=[[GHSpriteHexagon selectedHexagons]count];
    if (t1<2) return NO;
    
    GHSpriteHexagon *prevHex=[[GHSpriteHexagon selectedHexagons]objectAtIndex:(t1-2)];
    
    //if (([aHexagon isEqual:prevHex]))
    //    CCLOG(@"isHexagonPreviousHexagon:YES");
    
    return ([aHexagon isEqual:prevHex]);
    
}


#pragma mark - Bomb Methods

-(void)putBombSpriteTo:(GHSpriteHexagon *)parent
{
    CCSprite *dynamiteSprite_=[CCSprite spriteWithFile:@"dynamite.png"];
    
    CGPoint cpCenter=ccp(parent.boundingBox.size.width/2,parent.boundingBox.size.height/2);
    [parent addChild:dynamiteSprite_];
    [dynamiteSprite_ setPosition:cpCenter];
    
    //emitter start
    CCParticleSystemQuad *emitter=[CCParticleSystemQuad particleWithFile:@"dynamiteStarter.plist"];
    [emitter setTag:TAG_PARTICLE_FOUND];
    //[emitter resetSystem];
    [parent addChild:emitter];
    emitter.zOrder=100000;
    emitter.position=cpCenter;
    //end of emitter
    ////////////////////
}

-(void)onBombTimeOut:(NSTimer*)sender
{
    [self setIsBombTriggered:NO];
    [[WGSoundCore sharedDirector]playEffectSafeVolume:@"bombed.mp3"];
    [self bombAroundSprite];
    //NSLog(@"soundCounter - :%d %@",soundCounter,NSStringFromClass([sender class]));
    [sender invalidate];
}

-(void) bombAroundSprite
{
    //b2Body *bomberBody=[[self bombSprite]bodybody];
    
    b2Transform v1=[self.bombSprite bodybody]->GetTransform();
    CGPoint p1=CGPointMake(v1.p.x*PTM_RATIO,v1.p.y*PTM_RATIO);
    
    //CGPoint p1=[[self bombSprite]position];
    
    for (b2Body *b=world->GetBodyList(); b;b=b->GetNext())
    {
        GHSpriteHexagon *hx1=(GHSpriteHexagon*)b->GetUserData();
        if (!hx1)continue;
        
        NSString *cls1=NSStringFromClass([hx1 class]);
        bool bool1=[cls1 isEqualToString:@"GHSpriteHexagon"];
        if (!bool1)
            continue;
        // if([self isHexagonSameLastSelectedHexagon:hx1])
        //     continue;
        
        b2Transform v2=b->GetTransform();
        CGPoint p2=CGPointMake(v2.p.x*PTM_RATIO,v2.p.y*PTM_RATIO);
        
        float distance_=ccpDistance(p1, p2);
        NSLog(@"Distance:%f Letter:%@",distance_,[hx1 letter]);
        
        float dist_val_=([KTHardwareUtils isIPad])?60:45;//eğer cihaz ipad ise bloklar arası uzaklık değişiyor o yüzden bu.
        
        if(distance_<dist_val_)
        {
            [[GHSpriteHexagon selectedHexagons]addObject:hx1];
        }
    }
    
    [self animatePopsAndDestroy];
    [self setIsBombMode:NO];
    [self setBombSprite:NULL];
    
    if([KTHardwareUtils isIPad])//ipad ve iphone da düğmeler farklı o yüzden bu if
    {
        CCMenuAdvanced *bottom_menu_=(CCMenuAdvanced*)[self getChildByTag:TAG_BOTTOM_BUTTON_MENU];
        [bottom_menu_ setVisible:YES];
        CCMenuItemToggle *mBomb=(CCMenuItemToggle*)[bottom_menu_ getChildByTag:TAG_TOGGLE_BOMB_MENUITEM];
        [mBomb setSelectedIndex:0];
    }
    else{
        CCMenuAdvanced *bottom_menu=(CCMenuAdvanced*)[self getChildByTag:TAG_CORNER_MENU3];
        CCMenuItemToggle *mBomb=(CCMenuItemToggle*)[bottom_menu getChildByTag:TAG_TOGGLE_BOMB_MENUITEM];
        [mBomb setSelectedIndex:0];
    }
}

-(void)animatePopsAndDestroy
{
    CGPoint p,p2;
    for (GHSpriteHexagon *ee in [GHSpriteHexagon selectedHexagons])
    {
        CCLabelBMFont *harf=[[ee children]objectAtIndex:0];
        
        p=ccp(ee.bodybody->GetPosition().x*PTM_RATIO,ee.bodybody->GetPosition().y*PTM_RATIO);
        ee.bodybody->SetActive(NO);
        //GHSprite *spr1=[GHSprite spriteWithSpriteFrameName:@"6gensari"];
        //[self addChild:spr1];
        //[spr1 setPosition:p];
        ee.bodybody->SetType(b2_staticBody);
        
        int plus_y_=randIntBetween(-200, -300);
        p2=[self getAxisYPositionWithPlus:p WithPlus:plus_y_];
        
        // world->DestroyBody(ee.bodybody);
        
        [ee setPosition:p];
        [ee setScale:1];
        
        id a=[CCMoveTo actionWithDuration:1 position:p2];
        id b=[CCFadeOut actionWithDuration:1];
        
        int angle_=randIntBetween(-180, 180);
        id c=[CCRotateBy actionWithDuration:1 angle:angle_];
        id d=[CCEaseOut actionWithAction:a rate:.45];
        id z=[CCCallFunc actionWithTarget:self selector:@selector(postDestroyAllHexagons)];
        id spw=[CCSpawn actions:a,b,c,d, nil];
        id s=[CCSequence actions:spw,z, nil];
        [ee runAction:s];
        [harf runAction:[b copy]];
        
        if ([[ee children]count]==3)
        {
            CCParticleSystemQuad *fireStarterParticle =[[ee children]objectAtIndex:2];
            [fireStarterParticle stopSystem];
            [fireStarterParticle removeFromParentAndCleanup:YES];
            
            CCSprite *dynamiteSpr=(CCSprite*)[[ee children]objectAtIndex:1];
            [dynamiteSpr removeFromParentAndCleanup:YES];
        }
        
    }//end of for -
}

-(void)postDestroyAllHexagons
{
    for (GHSpriteHexagon *ee in [GHSpriteHexagon selectedHexagons])
    {
        
        world->DestroyBody(ee.bodybody);
        CCLabelBMFont *harf=[[ee children]objectAtIndex:0];
        [harf removeFromParentAndCleanup:YES];
        [ee removeFromParentAndCleanup:YES];
    }
    [[GHSpriteHexagon selectedHexagons]removeAllObjects];
}
//end of bomb methods


- (BOOL)isWordExists:(NSString *)wordString {
    
    //önceden seçilmişse yok de.
    BOOL isWordPoppedBefore=[WGThemeCore isWordPoppedBefore:wordString];
    if (isWordPoppedBefore) return NO;
    
    //AppController *appdelegate=[[UIApplication sharedApplication]delegate];
    NSString *fg_=[[NSBundle mainBundle]pathForResource:@"words" ofType:@"rdb"];
    FMDatabase *db = [FMDatabase databaseWithPath:fg_];
    [db open];
    
    NSString *sqltext_=[NSString stringWithFormat:@"SELECT count(*) from words where term='%@'", wordString];
    NSUInteger count_=[db intForQuery:sqltext_];
    [db close];
    
    //eğer vt de seçilen kelime varsa poppedWords.pliste yaz.
    if(count_>0)
        [WGThemeCore appendWordToPoppedWords:wordString];
    
    return (count_>0);
}

#pragma mark swap two hexagons methods
-(void)autonomSwap
{
    int tot_= [[GHSpriteHexagon selectedHexagons]count];
    //CCLOG(@"tot_: %d",tot_);
    if (tot_==2)
    {
        if (self.swapTimer!=nil)
        {
            [self.swapTimer invalidate];
            self.swapTimer=nil;
        }
        self.swapTimer=[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(postSwapHexagons:) userInfo:nil repeats:NO];
        // CCLOG(@"swapMode triggered");
        
    }
    else
    {
        if(self.swapTimer!=nil)
            [self.swapTimer invalidate];
        //  CCLOG(@"swapMode untriggered");
    }
    ;
}

-(void)postSwapHexagons:(NSTimer*)sender
{
    [sender invalidate];
    self.swapTimer=nil;
    
    int tot_= [[GHSpriteHexagon selectedHexagons]count];
    
    if (tot_==2)
    {
        
        int r01=(arc4random()%5)+1;
        NSString *fn_=[NSString stringWithFormat:@"swap%d.mp3",r01];
        [[SimpleAudioEngine sharedEngine]playEffect:fn_];
        
        
        [self setIsWorldStepPaused:YES];
        GHSpriteHexagon *hx1=[[GHSpriteHexagon selectedHexagons]objectAtIndex:0];
        GHSpriteHexagon *hx2=[[GHSpriteHexagon selectedHexagons]objectAtIndex:1];
        
        //CGPoint tmp2=[hx2 position];
        
        
        b2Body *bhx1=[hx1 bodybody];
        b2Body *bhx2=[hx2 bodybody];
        bhx1->SetAwake(YES);
        bhx1->SetAwake(YES);
        b2Vec2 bthx1=bhx1->GetPosition();//GetWorldCenter();// GetTransform();
        b2Vec2 bthx2=bhx2->GetPosition();//GetWorldCenter();//GetTransform();
        
        CGPoint p1=ccp(bthx1.x*PTM_RATIO,bthx1.y*PTM_RATIO);
        CGPoint p2=ccp(bthx2.x*PTM_RATIO,bthx2.y*PTM_RATIO);
        
        //CGPoint p1=[hx1 position];
        //CGPoint p2=[hx2 position];
        id a=[CCMoveTo actionWithDuration:.3f position:p1];
        id fa=[CCCallFuncN actionWithTarget:self selector:@selector(resumeWorld)];
        id b=[CCMoveTo actionWithDuration:.3f position:p2];
        
        id seqa=[CCSequence actions:a,fa, nil];
        [hx1 setPosition:p1];
        [hx2 setPosition:p2];
        [hx2 runAction:seqa];
        [hx1 runAction:b];
    }
    
}

-(void)resumeWorld
{
    [self setIsWorldStepPaused:NO];
}


@end
