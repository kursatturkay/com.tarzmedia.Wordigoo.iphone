//
//  PhotoSprite.h
//  wordigoo-iphone
//
//  Created by Kursat Turkay on 15.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"

@interface PhotoSprite : CCSprite<CCTouchOneByOneDelegate>
{
    BOOL _isDragging;
    BOOL _isClicked;
    BOOL _isActionRunning;
}
@end
