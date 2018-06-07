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
//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#import "AudioVisualization.h"


@interface SoloGameLayer : CommonGameLayer<AudioVisualizationProtocol>{
    //BOOL nothingTouched;
    }
+(CCScene *) scene_;

@property(nonatomic)unsigned int totalScore;
-(void)putCup:(CGPoint)p;
-(void)generateHexagonAtPosition:(CGPoint)p withLetter:(NSString*)aletter;

@end
