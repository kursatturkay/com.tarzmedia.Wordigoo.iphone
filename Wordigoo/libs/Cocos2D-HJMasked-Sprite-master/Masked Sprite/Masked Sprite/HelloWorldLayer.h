//
//  HelloWorldLayer.h
//  Masked Sprite
//
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "HJMaskedSprite.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{
    HJMaskedSprite * demoSprite;
    CCSprite * normalSprite;
    CCSprite * overlaySprite;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
