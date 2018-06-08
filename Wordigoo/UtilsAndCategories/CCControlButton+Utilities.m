//
//  CCControlButton+Utilities.m
//  wordigoo-iphone
//
//  Created by Kursat Turkay on 11.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "CCControlButton+Utilities.h"
#import "cocos2d.h"
#import "CCScale9Sprite.h"
#import "WGThemeCore.h"

@implementation CCControlButton (Utilities)

+ (CCControlButton *)standardButtonWithTitle:(NSString *)title andFontSize:(CGFloat)afontsize
{
    /** Creates and return a button with a default background and title color. */
    CCScale9Sprite *backgroundButton = [CCScale9Sprite spriteWithFile:@"button.png"];
    CCScale9Sprite *backgroundHighlightedButton = [CCScale9Sprite spriteWithFile:@"buttonHighlighted.png"];
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    CCLabelTTF *titleButton = [CCLabelTTF labelWithString:title fontName:@"Helvetica" fontSize:afontsize];
#elif __MAC_OS_X_VERSION_MAX_ALLOWED
    CCLabelTTF *titleButton = [CCLabelTTF labelWithString:title fontName:@"Marker Felt" fontSize:afontsize];
#endif
    
    CCControlButton *button = [CCControlButton buttonWithLabel:titleButton backgroundSprite:backgroundButton];
    [button setBackgroundSprite:backgroundHighlightedButton forState:CCControlStateHighlighted];
    [button setTitleColor:[WGThemeCore getHexagonFontColor] forState:CCControlStateNormal];
    
    [button setColor:[WGThemeCore getHexagonColor]];
    [titleButton setColor:[WGThemeCore getHexagonFontColor]];

    return button;
}
@end
