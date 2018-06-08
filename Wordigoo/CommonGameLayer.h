//
//  CommonGameLayer.h
//  wordigoo
//
//  Created by Kursat Turkay on 16.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "CCNode.h"
#import "GHSpriteHexagon.h"
#import "GHSpriteContactListener.h"
@interface CommonGameLayer : CCLayerColor
{
    CCSpriteBatchNode *batchNodeParent;//TODO-nedir bu abi ya ne gerek var silsem nolacakki araştır.
	b2World* world;					// strong ref
    GHSprite *cupSprite;
    GHSpriteContactListener *ghSpriteContactListener_;
    BOOL orient_timeout_triggered;
    int victim_hexagon;//rastgele seçilen varolan hexagon numarası. müziğe göre ses dalgası için.
}
@property(nonatomic)UIDeviceOrientation lastOrientation;

@property(nonatomic)BOOL nothingTouched;
@property(nonatomic)BOOL isCloneMode;
@property(nonatomic)BOOL isBombMode;
@property(nonatomic)BOOL isWorldStepPaused;

@property(nonatomic,assign)BOOL isBombTriggered;

@property(nonatomic,assign)GHSpriteHexagon *cloneSprite;
@property(nonatomic,assign)GHSpriteHexagon *bombSprite;
@property(nonatomic,retain)NSTimer *swapTimer;

@property(nonatomic,assign)int soundFxHandle;

@property (nonatomic) b2World *world;
@property(nonatomic,retain)GHSprite *cupSprite;
@property(nonatomic,retain)NSString *lastFoundWord;

+(void)playNextMusic;

-(void)isHexagonActionStopped:(GHSpriteHexagon*)sender;
-(void)effectHexagonsWave:(float)level;
-(BOOL)isAllHexagonsStopped;
-(BOOL)isHexagonSameLastSelectedHexagon:(GHSpriteHexagon*)aHexagon;
-(BOOL)isHexagonNearLastSelectedHexagon:(GHSpriteHexagon*)aHexagon;

-(CGFloat)getRotateByOrientation:(UIDeviceOrientation)orientation;
-(void)rotateLettersTo:(UIDeviceOrientation)orientation;
-(void)rotateHexagonLetterToNormal:(GHSpriteHexagon*)hx;
-(CGPoint)getAxisYPositionWithPlus:(CGPoint)point WithPlus:(int)withplus;
-(NSString*)getSelectedWord:(BOOL)lowerCased;
-(BOOL)isHexagonPreviousHexagon:(GHSpriteHexagon*)aHexagon;

-(void)putBombSpriteTo:(GHSpriteHexagon *)parent;
-(void) bombAroundSprite;
-(void)onBombTimeOut:(NSTimer*)sender;
-(void)animatePopsAndDestroy;
-(void)postDestroyAllHexagons;
- (BOOL)isWordExists:(NSString *)wordString;

-(void)autonomSwap;
@end
