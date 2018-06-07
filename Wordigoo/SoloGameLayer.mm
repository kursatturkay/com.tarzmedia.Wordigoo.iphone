
#import "SoloGameLayer.h"
#import "SoloGameLayer+UI.h"

#import "WGThemeCore.h"
#import "GHSpriteHexagon.h"
#import "GeneralUtilities.h"
#import "SimpleAudioEngine.h"
#import "NSString+Utils.h"

#import "GlobalDefines.h"
#import "CCBoardLayer.h"
#import "CCMenuAdvanced.h"

#import "UIColor+Utils.h"
#import "KTHardwareUtils.h"
#import "KTBingoEngine.h"
#import "WGSoundCore.h"

#import "IntroLayer.h"
#import "Medal.h"

#pragma mark - SoloGameLayer

@implementation SoloGameLayer

@synthesize totalScore;

+(CCScene *) scene_
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SoloGameLayer *layer = [SoloGameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void)preOrientationChanged:(NSNotification*)notification
{
    orient_timeout_triggered=YES;
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(orientCounter) userInfo:nil repeats:NO];
}

-(void) orientCounter
{
    if(orient_timeout_triggered==YES)
    {
        orient_timeout_triggered=NO;
        [self postOrientationChanged];
    }
}

-(void)postOrientationChanged
//    {
//-(void)orientationChanged:(NSNotification*)notification
{
    UIDeviceOrientation orientation=[[UIDevice currentDevice]orientation];
    BOOL isKnownRotation=(orientation==UIDeviceOrientationPortrait)||(orientation==UIDeviceOrientationPortraitUpsideDown)||
    (orientation==UIDeviceOrientationLandscapeLeft)||(orientation==UIDeviceOrientationLandscapeRight);
    if(!isKnownRotation)orientation=UIDeviceOrientationPortrait;
    
    b2Vec2 gravity;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            gravity.Set(-5.0f, 0.0f);
            break;
            
        case UIDeviceOrientationLandscapeRight:
            gravity.Set(5.0f, 0.0f);
            break;
        case UIDeviceOrientationPortrait:
            gravity.Set(0.0f, -5.0f);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            gravity.Set(0.0f, 5.0f);
            break;
        default:
            break;
    }
    
    if(isKnownRotation)
    {
        [self setLastOrientation:orientation];
        [self rePositionBoard:orientation];
        
        world->SetAllowSleeping(NO);
        world->SetGravity(gravity);
        [self rotateLettersTo:orientation];
        
        world->SetAllowSleeping(YES);
        
        BOOL a=[[WGSoundCore sharedDirector]getMusicMutedFromSettings];
        BOOL b=[[WGSoundCore sharedDirector]getChangeMusicOnRotationFromSettings];
        
        if (!a)
            if(b)
            {
                [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
                [AudioVisualization removeSharedAv];
                [CommonGameLayer playNextMusic];
                [[AudioVisualization sharedAV] addDelegate:self forChannel:0];
            }
        
    }
}

-(id)init{
    [WGThemeCore reShuffleColorIndexes:NO];
    self = [super initWithColor:[WGThemeCore getBackgroundColor]];
    
    if(self){
        [[SimpleAudioEngine sharedEngine]playEffect:@"dundin.mp3"];
        
        [self setIsBombMode:NO];
        [self setIsCloneMode:NO];
        [self setIsBombTriggered:NO];
        
        self.cloneSprite=NULL;
        orient_timeout_triggered=NO;
        totalScore=0;
        self.lastFoundWord=[NSString string];
        self.nothingTouched=YES;
        self.touchEnabled = YES;
		self.accelerometerEnabled = YES;
        
        [self setLastOrientation:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(preOrientationChanged:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
        
        ghSpriteContactListener_=new GHSpriteContactListener();
        
        [self initTest];
        [self initBoard];
        [self loadSoloGameState];
        [self scheduleUpdate];
    }
    return self;
}

-(void)onEnter
{
    [super onEnter];
    [self postOrientationChanged];
    
    /*
     [[SimpleAudioEngine sharedEngine]stopBackgroundMusic];
     [AudioVisualization removeSharedAv];
     [CommonGameLayer playNextMusic];
     [[AudioVisualization sharedAV] addDelegate:self forChannel:0];
     */
}

- (void) avAvgPowerLevelDidChange:(float) level channel:(ushort) theChannel
{
    if (level>1)return;
    int x=world->GetBodyCount();
    
    victim_hexagon=(arc4random()%x)+3;
    //CCLOG(@"victim_hexagon_:%d",victim_hexagon);
    if (level>0.05f)
        [self effectHexagonsWave:level];
}
-(void)actTouches:(NSSet*)touches
{
    UITouch *touch1=[touches anyObject];
    //[self logLastSelectedHexagon];
    
    for(b2Body *b=world->GetBodyList();b;b=b->GetNext())
    {
        GHSpriteHexagon *hx1=(GHSpriteHexagon*)b->GetUserData();
        if (!hx1)continue;
        
        NSString *cls1=NSStringFromClass([hx1 class]);
        bool bool1=[cls1 isEqualToString:@"GHSpriteHexagon"];
        if (!bool1)
            continue;
        
        if([self isHexagonSameLastSelectedHexagon:hx1])
            continue;
        
        //eğer sıradaki bloğa dokunmuşsa~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        BOOL b1=[self isHexagonNearLastSelectedHexagon:hx1];//eğer hx1 son seçilene yakınsa
        
        if (([hx1 containsTouchLocation:touch1])&&b1)
        {
            self.nothingTouched=NO;
            
            //eğer seçilen sondan bir öncekiyse sonuncuyu iptal et.
            if ([self isHexagonPreviousHexagon:hx1])
            {
                GHSpriteHexagon *hxLast=[[GHSpriteHexagon selectedHexagons]lastObject];
                [[GHSpriteHexagon selectedHexagons]removeLastObject];
                
                CCSpriteFrameCache *cache=[CCSpriteFrameCache sharedSpriteFrameCache];
                CCSpriteFrame *frame1=[cache spriteFrameByName:@"6gen"];
                [hxLast setDisplayFrame:frame1];
                
                // if(!(b->IsAwake()))
                //[[SimpleAudioEngine sharedEngine]playEffect:@"hex0.mp3"];
                float harf_sayisi_=([[self getSelectedWord:NO]length]/10.0f)+1;
                self.soundFxHandle=[[WGSoundCore sharedDirector]playEffectSafeVolume:@"hex0.mp3"  pitch:harf_sayisi_ pan:0.0f gain:1.0f];
                
                continue;
            }
            
            BOOL isHx1Exists_=([[GHSpriteHexagon selectedHexagons]containsObject:hx1]);
            
            if (!isHx1Exists_)
            {
                [[GHSpriteHexagon selectedHexagons]addObject:hx1];
                [[SimpleAudioEngine sharedEngine]stopEffect:self.soundFxHandle];
                
                float harf_sayisi_=([[self getSelectedWord:NO]length]/10.0f)+1;
                self.soundFxHandle=[[WGSoundCore sharedDirector]playEffectSafeVolume:@"hex1.mp3"  pitch:harf_sayisi_ pan:0.0f gain:1.0f];
                
                //int sum1=[[GHSpriteHexagon selectedHexagons]count];
                //NSLog(@"selectedHexagons:%d",sum1);
                
            }
            CCSpriteFrameCache *cache=[CCSpriteFrameCache sharedSpriteFrameCache];
            CCSpriteFrame *frame1=[cache spriteFrameByName:@"6gensari"];
            [hx1 setDisplayFrame:frame1];
        }//end of if..
        
        //TODO - getSelectedWord ile seçilen kelime burda biyerlere yazdırılacak
        //[self drawBoard];
        
    }//end of for..
    [self setFoundWordLabel:[self getSelectedWord:NO]];
}

#pragma mark > Bomb methods
-(void)actTouchesInBombMode:(NSSet*)touches
{
    UITouch *touch1=[touches anyObject];
    
    for(b2Body *b=world->GetBodyList();b;b=b->GetNext())
    {
        GHSpriteHexagon *hx1=(GHSpriteHexagon*)b->GetUserData();
        if (!hx1)continue;
        
        NSString *cls1=NSStringFromClass([hx1 class]);
        bool bool1=[cls1 isEqualToString:@"GHSpriteHexagon"];
        if (!bool1)
            continue;
        
        if([self isHexagonSameLastSelectedHexagon:hx1])
            continue;
        
        //eğer sıradaki bloğa dokunmuşsa~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        if (([hx1 containsTouchLocation:touch1]))
        {
            self.nothingTouched=NO;
            
            if ([self bombSprite]==NULL)//bomb modda ve hiçbirşey bomblamak için seçilmemişse henüz: seç.
            {
                //[[WGSoundCore sharedDirector]playEffectSafeVolume:@"clonePressed.mp3"];
                [self setBombSprite:hx1];
                //[self bombAroundSprite];
                [[WGSoundCore sharedDirector]playEffectSafeVolume:@"bombTriggered.mp3"];
                [self setIsBombTriggered:YES];
                [self putBombSpriteTo:[self bombSprite]];
                [NSTimer scheduledTimerWithTimeInterval:1.1 target:self selector:@selector(onBombTimeOut:) userInfo:nil repeats:NO];
            }
            else//bomb modda zaten bir tane bomb boncuk seçilmişse
            {
            }
        }
        
    }
}

-(void)actTouchesInCloneMode:(NSSet*)touches
{
    UITouch *touch1=[touches anyObject];
    
    for(b2Body *b=world->GetBodyList();b;b=b->GetNext())
    {
        GHSpriteHexagon *hx1=(GHSpriteHexagon*)b->GetUserData();
        if (!hx1)continue;
        
        NSString *cls1=NSStringFromClass([hx1 class]);
        bool bool1=[cls1 isEqualToString:@"GHSpriteHexagon"];
        if (!bool1)
            continue;
        
        if([self isHexagonSameLastSelectedHexagon:hx1])
            continue;
        
        //eğer sıradaki bloğa dokunmuşsa~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        if (([hx1 containsTouchLocation:touch1]))
        {
            self.nothingTouched=NO;
            
            if ([self cloneSprite]==NULL)//clone modda ve hiçbirşey klonlanmak için seçilmemişse henüz seç.
            {
                [[WGSoundCore sharedDirector]playEffectSafeVolume:@"clonePressed.mp3"];
                [self setCloneSprite:hx1];
                id a=[CCTintTo actionWithDuration:0.5 red:128 green:0 blue:0];
                id b=[CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255];
                id s=[CCSequence actions:a,b, nil];
                id r=[CCRepeatForever actionWithAction:s];
                [hx1 runAction:r];
            }
            else//clone modda zaten bir tane klonlanacak boncuk seçilmişse
            {
                [[WGSoundCore sharedDirector]playEffectSafeVolume:@"cloneApplied.mp3"];
                [hx1 setLetter:[[self cloneSprite]letter]];
                CCLabelBMFont *innerLetter=(CCLabelBMFont*)[[hx1 children]objectAtIndex:0];
                [innerLetter  cleanup];
                [innerLetter setString:hx1.letter];
                
                [self.cloneSprite stopAllActions];
                
                ccColor3B c_=[WGThemeCore getHexagonColor];
                [self.cloneSprite runAction:[CCTintTo actionWithDuration:0.5f red:c_.r green:c_.g blue:c_.b]];
                
                [self setCloneSprite:NULL];
                
                CCMenuAdvanced *bottom_menu=(CCMenuAdvanced*)[self getChildByTag:TAG_CLONE_BUTTON_MENU];
                CCMenuItemToggle *m5=(CCMenuItemToggle*)[bottom_menu getChildByTag:TAG_TOGGLE_CLONE_MENUITEM];
                [m5 setSelectedIndex:0];
                [self setIsCloneMode:NO];
                
                if(self.totalScore>=100)
                    self.totalScore-=100;
                
                [self setScoreLabel:[NSString stringWithFormat:@"%d",[self totalScore]]];
                ////////////////////
                
                //emitter start
                CCParticleSystemQuad *emitter=[CCParticleSystemQuad particleWithFile:@"found.plist"];
                [emitter setTag:TAG_PARTICLE_FOUND];
                //[emitter resetSystem];
                [hx1 addChild:emitter];
                emitter.zOrder=100000;
                emitter.position=ccp(hx1.contentSize.width/2,hx1.contentSize.height/2);
                //end of emitter
                ////////////////////
            }
        }
        
    }
}

-(BOOL)isNothingTouched:(CGPoint)location
{
    BOOL ret_=YES;
    BOOL veryNearToOtherBlock=NO;
    
    //CGPoint p_=[touch locationInView:[touch view]];
    //p_=[[CCDirector sharedDirector]convertToGL:p_];
    
    for (b2Body *b=world->GetBodyList();b&&(ret_==YES); b=b->GetNext())
    {
        
        /////////////////////////
        b2Transform v2=b->GetTransform();
        CGPoint p2=CGPointMake(v2.p.x*PTM_RATIO,v2.p.y*PTM_RATIO);
        float distance_=ccpDistance(location, p2);
        
        GHSpriteHexagon *obj_=(GHSpriteHexagon*)b->GetUserData();
        
        NSString *cls1=NSStringFromClass([obj_ class]);
        
        if ([cls1 isEqualToString:@"GHSpriteHexagon"])
        {
            //NSLog(@"Distance:%f Letter:%@",distance_,[obj_ letter]);
            
            if (distance_<30)
            {
                veryNearToOtherBlock=YES;
                ret_=NO;
            }
            //float dist_val_=([KTHardwareUtils isIPad])?60:45;//e
        }
        
        ////////////////////////
        if (!veryNearToOtherBlock)
        {
            for(b2Fixture *b_fixture_=b->GetFixtureList();b_fixture_;b_fixture_=b_fixture_->GetNext())
            {
                
                //GHSpriteHexagon *obj_=(GHSpriteHexagon*)b->GetUserData();
                
                NSString *aaa=NSStringFromClass([obj_ class]);
                
                if ([aaa isEqualToString:@"GHSprite"])
                {
                    b2Vec2 locationWorld_ = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
                    
                    BOOL this_touched_=(b_fixture_->TestPoint(locationWorld_));
                    
                    if (this_touched_)
                    {
                        ret_=NO;
                        break;
                    }
                }//end of if aaa-
            }//end of for-
        }//end of if-
    }
    
    return ret_;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isBombTriggered])return;
    //NSLog(@"ccTouchesBegan");
    
    if ([self isCloneMode])
    {
        [self actTouchesInCloneMode:touches];
    }
    else if([self isBombMode])
    {
        [self actTouchesInBombMode:touches];
    }
    else
        [self actTouches:touches];
    
    [self autonomSwap];
    
}


-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isBombTriggered])return;
    if ([self isCloneMode])
    {
        [self actTouchesInCloneMode:touches];
    }
    else
        [self actTouches:touches];
    
    [self autonomSwap];
    
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isBombTriggered])return;
    //NSLog(@"ccTouchesEnded");
    //UITouch *touch1=[touches anyObject];
    for(b2Body *b=world->GetBodyList();b;b=b->GetNext())
    {
        GHSpriteHexagon *hx1=(GHSpriteHexagon*)b->GetUserData();
        if (!hx1)continue;
        
        
        NSString *cls1=NSStringFromClass([hx1 class]);
        bool bool1=[cls1 isEqualToString:@"GHSpriteHexagon"];
        if (!bool1)
            continue;
        
        //eğer sıradaki hexagon ise
        
        CCSpriteFrameCache *cache=[CCSpriteFrameCache sharedSpriteFrameCache];
        CCSpriteFrame *frame1=[cache spriteFrameByName:@"6gen"];
        [hx1 setDisplayFrame:frame1];
    }//end of for..
    
    
    if (self.nothingTouched)
    {
        for(UITouch *touch in touches)
        {
            CGPoint p=[touch locationInView:[touch view]];
            p=[[CCDirector sharedDirector]convertToGL:p];
            [self generateHexagonAtPosition:p withLetter:nil];
        }
        
    }   //  [super ccTouchesEnded:touches withEvent:event];
    else//!!!!eğer birşeyler seçilmişse
        [self destroyAllHexagons:2];
    
    self.nothingTouched=YES;
    
}

//patlayan kelimeler ortasında yeni eklenen puanı çıkarıp asıl puana ekletme animasyonu yapar
-(void)popAnimateAddedScore:(NSUInteger)newPoint
{
    CGFloat total_hexagons_;
    CGPoint average_point_;
    total_hexagons_=[[GHSpriteHexagon selectedHexagons]count];
    
    for (GHSpriteHexagon *ee in [GHSpriteHexagon selectedHexagons])
    {
        average_point_.x+=ee.bodybody->GetPosition().x*PTM_RATIO;
        average_point_.y+=ee.bodybody->GetPosition().y*PTM_RATIO;
    }
    average_point_.x=(average_point_.x/total_hexagons_);
    average_point_.y=(average_point_.y/total_hexagons_);
    
    NSNumberFormatter *formatter=[NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *newPointStr=[formatter stringFromNumber:[NSNumber numberWithUnsignedInteger:newPoint]];
    CCLabelBMFont *addedScoreLbl=[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"+%@",newPointStr] fntFile:@"chalkbuster_30.fnt"];
    [addedScoreLbl setColor:ccc3(255,255,255)];
    //average_point_=[self convertToNodeSpace:average_point_];
    //average_point_=[[CCDirector sharedDirector]convertToGL:average_point_];
    
    [self addChild:addedScoreLbl];
    [addedScoreLbl setPosition:average_point_];
    
    //emitter start
    CCParticleSystemQuad *emitter=[CCParticleSystemQuad particleWithFile:@"found.plist"];
    [emitter setTag:TAG_PARTICLE_FOUND];
    //[emitter resetSystem];
    [self addChild:emitter];
    emitter.zOrder=100000;
    emitter.position=average_point_;
    //end of emitter
    
    if (newPoint<100)
        [[WGSoundCore sharedDirector]playEffectSafeVolume:@"hexFound.mp3" pitch:1 pan:1 gain:1];
    else
        if (newPoint==100)
            [[WGSoundCore sharedDirector]playEffectSafeVolume:@"letterfound_5.mp3" pitch:1 pan:1 gain:1];
        else
            if (newPoint>100)
                [[WGSoundCore sharedDirector]playEffectSafeVolume:@"letterfound_6ormore.mp3" pitch:1 pan:1 gain:1];
    
    CCMenuAdvanced *top_menu=(CCMenuAdvanced*)[self getChildByTag:TAG_SOLO_SCORE_MENU_LAYER];
    CCLabelBMFont *score_lbl_= (CCLabelBMFont*)[top_menu getChildByTag:TAG_SOLO_SCORE_LABEL];
    
    [addedScoreLbl setRotation:[self getRotateByOrientation:self.lastOrientation]];
    
    CGPoint p2=[score_lbl_ convertToWorldSpace:[score_lbl_ position]];
    p2=ccp(p2.x,p2.y+(score_lbl_.contentSize.height));
    
    NSString *tmp_=[NSString stringWithFormat:@"%lu",newPoint];
    int scaleFactor_=(int)[tmp_ length]-1;
    
    id a=[CCMoveTo actionWithDuration:2 position:p2];
    id b=[CCFadeOut actionWithDuration:2];
    id c=[CCEaseIn actionWithAction:a rate:2];
    id d=[CCScaleTo actionWithDuration:2 scale:scaleFactor_];
    id s=[CCSpawn actions:b,c,d, nil];
    id cf=[CCCallFuncN actionWithTarget:self selector:@selector(destroyParticle_found)];
    id seq=[CCSequence actions:s,cf, nil];
    [addedScoreLbl runAction:seq];
}

-(void)destroyParticle_found
{
    CCParticleSystemQuad *particle=(CCParticleSystemQuad*)[self getChildByTag:TAG_PARTICLE_FOUND];
    [particle stopSystem];
    //[particle release];
    [self removeChildByTag:TAG_PARTICLE_FOUND cleanup:YES];
}

// biggerThan:0(zero)for destroy all hexagons
-(void)destroyAllHexagons:(int)biggerThan
{
    int c1=(int)[[GHSpriteHexagon selectedHexagons]count];
    if (c1<=biggerThan)
    {
        [[GHSpriteHexagon selectedHexagons]removeAllObjects];
        return;
    }
    
    //aranan kelime veritabnaında var mı ?
    NSString *selword_=[self getSelectedWord:YES];
    BOOL isWordExists_=[self isWordExists:selword_];
#pragma mark >Eğer bir kelime seçilmişse ve veritabanında varsa.
    if (isWordExists_)//!!!!seçilen kelime bulundu ise puanlama falan burda yap
    {
        [[CCDirector sharedDirector]pause];
        
        int total_=[[GHSpriteHexagon selectedHexagons]count];
        NSUInteger newPoint=[WGScoreCore getPointByLetterCount:total_];
        totalScore+=newPoint;
        
        bool isLevelUpgraded=[[Medal sharedMedal]checkandUpgradeLevelSignetByPoint:totalScore];
        
        if (isLevelUpgraded)
        {
            //totalScore=0;
            [[Medal sharedMedal]initMedalto:self];
            [[Medal sharedMedal]setRotateRelativeToDevice];
            [[[Medal sharedMedal]medalSprite] setScale:0];
            id a0=[CCScaleTo actionWithDuration:0 scale:0];
            id a=[CCScaleTo actionWithDuration:1 scale:1];
            id a1=[CCEaseElasticOut actionWithAction:a period:.45f];
            id b=[CCDelayTime actionWithDuration:2];
            id c=[CCScaleTo actionWithDuration:1 scale:0];
            
            id d=[CCCallBlockN actionWithBlock:
                  ^(CCNode *node){
                      [node removeFromParentAndCleanup:YES];
                  }];
            id s1=[CCSequence actions:a0,a1,b,c,d, nil];
            [[Medal sharedMedal].medalSprite runAction:s1];
            
        }
        
        [self popAnimateAddedScore:newPoint];
        [self animatePopsAndDestroy];
        
        [self setScoreLabel:[NSString stringWithFormat:@"%d",[self totalScore]]];
        [self setLastFoundWord:[selword_ uppercaseString]];
        [self setFoundWordLabel:[selword_ uppercaseString]];
        [[CCDirector sharedDirector]resume];
    }
    else
    {
        [[WGSoundCore sharedDirector]playEffectSafeVolume:@"hex0.mp3"];
        [self setFoundWordLabel:[self lastFoundWord]];
        [[GHSpriteHexagon selectedHexagons]removeAllObjects];
    }
    //[[SimpleAudioEngine sharedEngine]playEffect:@"hexFound.mp3"];
}

-(void) initPhysics
{
    CGSize s = [[CCDirector sharedDirector] winSize];
    b2Vec2 gravity;
    gravity.Set(-5.0f, 0.0f);
    world = new b2World(gravity);
    
    world->SetContactListener(ghSpriteContactListener_);
    // Do we want to let bodies sleep?
    world->SetAllowSleeping(true);
    
    world->SetContinuousPhysics(true);
    
    // Define the ground body.
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0); // bottom-left corner
    
    // Call the body factory which allocates memory for the ground body
    // from a pool and creates the ground box shape (also from a pool).
    // The body is also added to the world.
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    
    // Define the ground box shape.
    b2EdgeShape groundBox;
    
    // bottom
    groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    // top
    groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    // left
    groundBox.Set(b2Vec2((1.0f/PTM_RATIO),s.height/PTM_RATIO), b2Vec2((1.0f/PTM_RATIO),0));
    groundBody->CreateFixture(&groundBox,0);
    // right
    groundBox.Set(b2Vec2((s.width-1)/PTM_RATIO,s.height/PTM_RATIO), b2Vec2((s.width-1)/PTM_RATIO,0));
    groundBody->CreateFixture(&groundBox,0);
    
}

-(void) update:(ccTime)dt
{
    //It is recommended that a fixed time step is used with Box2D for stability
    //of the simulation, however, we are using a variable time step here.
    //You need to make an informed choice, the following URL is useful
    //http://gafferongames.com/game-physics/fix-your-timestep/
    
    int32 velocityIterations = 8;
    int32 positionIterations = 1;
    
    if(![KTHardwareUtils isIPADHD])
    {
        velocityIterations = 20;
        positionIterations = 20;
    }
    // Instruct the world to perform a single step of simulation. It is
    // generally best to keep the time step and iterations fixed.
    
    //if (dt<1)
    if ([self isWorldStepPaused])dt=0;
    world->Step(dt, velocityIterations, positionIterations);
    //static BOOL a=YES;
    
    /*
     if(![self isAllHexagonsStopped])
     {
     NSLog(@"isAllHexagonsStopped");
     }
     */
}


-(void)initTest{
    
    CGSize s = [CCDirector sharedDirector].winSize;
    [self initPhysics];
    //GHDebugDrawLayer* debugDraw = [GHDebugDrawLayer debugDrawLayerWithWorld:world];
    //[self addChild:debugDraw z:1000];
#if 1
    // Use batch node. Faster
    //when using batches - load a batch node using the generated image
    //batchNodeParent = [CCSpriteBatchNode batchNodeWithFile:@"PhysicalSpritesObjects_Objects.pvr" capacity:100];
    //[self addChild:batchNodeParent z:0];
#endif
    //load into the sprite frame cache the plist generated by SH
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    //SpriteFramesFromFile:@"PhysicalSpritesObjects_Objects.plist"]];
    //NSString *a=[KTHardwareUtils getDeviceModel];
    //if ([[KTHardwareUtils getDeviceModel]isEqualToString:@"iPhone5"])
    
    //#define IS_IPHONE5 (([[CCDirector sharedDirector]winSize].height-568)?NO:YES)
    
    
    
    if(IS_IPHONE5)
    {
        NSString *plistfn_=[NSString stringWithFormat:@"PhysicalSpritesObjects_IPhone5.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistfn_];
        [self putCup:ccp(s.width/2, s.height/2)];
    }
    else if(IS_IPAD)
    {
        NSString *plistfn_= [NSString stringWithFormat:@"PhysicalSpritesObjects_ipadhd.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistfn_];
        [self putCup:ccp(s.width/2, s.height/2)];
    }
    else if(IS_IPHONE4_ORLOWER)
    {
        NSString *plistfn_=[NSString stringWithFormat:@"PhysicalSpritesObjects_IPhone4.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:plistfn_];
        [self putCup:ccp(s.width/2, s.height/2)];
    }
}

-(void)putCup:(CGPoint)p
{
    NSString* sprFrameName = @"quibble_hive";
    [[GHDirector sharedDirector] setPhysicalWorld:world];
    [[GHDirector sharedDirector] setPointToMeterRatio:PTM_RATIO];
    cupSprite = [GHSprite spriteWithSpriteFrameName:sprFrameName];
    [self addChild:cupSprite];
    [cupSprite setPosition:p];
    
}

-(int)totalHexagons
{
    int ret_=0;
    
    for(b2Body *b=world->GetBodyList();b;b=b->GetNext())
    {
        GHSpriteHexagon *cisim_= (GHSpriteHexagon*)b->GetUserData();
        if(!b)break;
        NSString *clsname_=NSStringFromClass([cisim_ class]);
        
        if([clsname_ isEqualToString:@"GHSpriteHexagon"])
            ret_++;
    }
    return ret_;
}

-(void)generateHexagonAtPosition:(CGPoint)p withLetter:(NSString*)aletter
{
    int sum_=[self totalHexagons];
    if (sum_>MAX_HEXAGONS)return;
    
    if (![self isNothingTouched:p])
        return;
    
    NSString* sprFrameName = @"6gen";
    //set the current world you want to use when creating bodies
    //in case you have multiple worlds just set the coresponding world before creating the sprites
    //CAREFULL - when deleting the box2d world you should also pass NULL to this method
    [[GHDirector sharedDirector] setPhysicalWorld:world];
    
    //set your custom PTM_RATIO
    [[GHDirector sharedDirector] setPointToMeterRatio:PTM_RATIO];
    
    //if you want to load color, opacity and other properties set on sprites inside SH
    //you must use a GHSprite to do that.
    //GHSprite is a subclass of CCSprite that adds some helper methods
    GHSpriteHexagon* newSpr = [GHSpriteHexagon spriteWithSpriteFrameName:sprFrameName];
    [newSpr setColor:[WGThemeCore getHexagonColor]];
    [newSpr setTag:799];
    b2Body *bb= [GHSpriteHexagon getBodyForSprite:newSpr inWorld:world];
    [newSpr setBodybody:bb];
    
    //else you can also use a CCSprite
    //    CCSprite* newSpr = [CCSprite spriteWithSpriteFrameName:sprFrameName];
    
    [newSpr setPosition:p];
    
    NSString *let_=nil;
    
    if (!aletter)
    {
        // ESKİ YÖNTEM-KTBingoEngine ile değiştirildi.
        let_=[NSString reBuildEnglishMostUsedLetterList];
        let_=[NSString randomAlphanumericStringWithLengthAndLetters:1 letters:let_];
        //
        //let_=[[KTBingoEngine sharedEngine]randomLetter];
    }
    else
        let_=aletter;
    
    [newSpr setLetter:let_];
    
    CCLabelBMFont *fnt_=[CCLabelBMFont labelWithString:let_ fntFile:@"comicsansms_70.fnt"];
    [fnt_ setColor:[WGThemeCore getHexagonFontColor]];
    
    [newSpr addChild:fnt_ z:0];
    CGPoint p1=CGPointMake(newSpr.boundingBox.size.width/2, newSpr.boundingBox.size.height/2);
    [fnt_ setPosition:p1];
    [self rotateHexagonLetterToNormal:newSpr];
    
    //eğer yeni bir harf eklenmişse 2 puan düş
    //loadstate ise aletter doludur.bu puan düşme işlemi loadstate de olmayacaktır.
    if ((totalScore>0)&&(!aletter))
    {
        totalScore-=2;
        [self setScoreLabel:[NSString stringWithFormat:@"%d",[self totalScore]]];
    }
    //[newSpr addChild:ttf_ z:0];
    
    /*if(batchNodeParent != nil){//if we use batch nodes we must add the sprite to its batch parent
     [batchNodeParent addChild:newSpr];
     }
     else{//if we dont use batch nodes then we must add the sprite to a normal node - e.g the layer or another node
     */
    [self addChild:newSpr];
    // }
    
    //!!! yeni boncuga baskı yapıyordu.
    //bb->ApplyForce(b2Vec2(0,200),bb->GetWorldCenter());
    
    //bb->SetLinearVelocity(b2Vec2(0,0));
    /*ANIMASYON BLOKU
     GHAnimationCache *cache = [GHAnimationCache sharedAnimationCache];
     GHAnimation *animation = [cache animationByName:@"run"];//the name of the animation
     
     [newSpr prepareAnimation:animation];
     [newSpr playAnimation];
     
     // [newSpr setAnimationDelegate:self];
     */
}

-(void)dealloc{
    //[self setLastOrientation:UIDeviceOrientationPortrait];
    //[[UIDevice currentDevice]endGeneratingDeviceOrientationNotifications];
    //[NSNotificationCenter defaultCenter]removeObserver:<#(id)#>
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    
    
    
    delete world;
    world = NULL;
    
    //    delete m_debugDraw;
    //    m_debugDraw = NULL;
    
    
    [[GHDirector sharedDirector] setPhysicalWorld:NULL];
    
    [super dealloc];
}
@end
/*
 -(void)draw
 {
 
 GHSpriteHexagon *hx1=
 [[GHSpriteHexagon selectedHexagons]lastObject];
 
 if (hx1)
 {
 b2Body *b=[hx1 bodybody];
 b2Transform v2=b->GetTransform();
 CGPoint p1=CGPointMake(v2.p.x*PTM_RATIO,v2.p.y*PTM_RATIO);
 
 CGPoint p2=CGPointMake(1,1);
 ccDrawRect(p1, p2);
 }
 
 [super draw];
 }
 */

//debug purposes only.removed if not needed.
/*
 -(void)logLastSelectedHexagon
 {
 GHSpriteHexagon *hxLast=[[GHSpriteHexagon selectedHexagons]lastObject];
 if (!hxLast)return;
 
 b2Body *b=[hxLast bodybody];
 b2Transform v2=b->GetTransform();
 CGPoint pp=CGPointMake(PTM_RATIO*v2.p.x,PTM_RATIO*v2.p.y);
 //CCLOG(@"hxLast.position:%@ hx1.letter:%@",NSStringFromCGPoint(pp),hxLast.letter);
 
 }
 */
