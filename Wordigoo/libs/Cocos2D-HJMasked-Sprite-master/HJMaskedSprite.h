//
//  HJMaskedSprite.h
//
//
//

#import "cocos2d.h"


@interface HJMaskedSprite : CCSprite{
    CCTexture2D * _maskTexture;
    GLuint _textureLocation;
    GLuint _maskLocation;
}
-(id)initWithSprite:(CCSprite*)sprite andMaskSprite:(CCSprite*)maskSprite;
-(id)initWithSprite:(CCSprite*)sprite andImageOverlay:(NSString*)maskFile;
-(id)initWithSpriteFrame:(CCSpriteFrame*)spriteFrame andMaskPattern:(NSString*)maskFile;
-(id)initWithFile:(NSString *)file andImageOverlay:(NSString*)maskFile;
-(id)initWithFile:(NSString *)file andMaskPatternSpriteFrame:(CCSpriteFrame*)mask;

@end
