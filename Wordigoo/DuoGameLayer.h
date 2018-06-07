//
// cocos2d
//
#import "CommonGameLayer.h"

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

#import "GameDevHelper.h"
#import "GHSpriteContactListener.h"
#import "GHSpriteHexagon.h"
#import "AudioVisualization.h"
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.

enum PlayerType {
    P1,P2};
    
@interface DuoGameLayer : CommonGameLayer<AudioVisualizationProtocol>{
    int totalscoreP1_;
    int totalscoreP2_;
}
+(CCScene *) scene_;
@property(nonatomic)PlayerType CurrentPlayer;

-(void)putCup:(CGPoint)p;
-(void)generateHexagonAtPosition:(CGPoint)p withLetter:(NSString*)aletter;

-(int) totalScoreforCurrentPlayer;
-(void) setTotalScoreforCurrentPlayer:(NSUInteger)totalscore;


@end
