//
//  ScalableMenuItemImage.m
//  Wordigoo
//
//  Created by Kursat Turkay on 15.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "ScalableMenuItemImage.h"
#import "cocos2d.h"

@implementation ScalableMenuItemImage

+(id) itemWithNormalImage: (NSString*)value selectedImage:(NSString*) value2 disabledImage: (NSString*) value3 target:(id) t selector:(SEL) s {
    return [[[self alloc] initWithNormalImage:value selectedImage:value2 disabledImage:value3 target:t selector:s] autorelease];
}

+(id) itemWithNormalImage: (NSString*)value selectedImage:(NSString*) value2 disabledImage:(NSString*) value3 block:(void(^)(id sender))block {
    return [[[self alloc] initWithNormalImage:value selectedImage:value2 disabledImage:value3 block:block] autorelease];
}

-(void) selected {
    [super selected];
    [self runAction:[CCScaleTo actionWithDuration:0.05 scale:1.2]];
}

-(void) unselected {
    [super unselected];
    [self runAction:[CCScaleTo actionWithDuration:0.05 scale:1.0]];
}

-(void) activate {
    // Scale out item before running normal click behaviour
    [self runAction:[CCSequence actions:
                     [CCScaleTo actionWithDuration:0.15 scale:1],
                     [CCDelayTime actionWithDuration:0.02],
                     [CCCallBlock actionWithBlock:^(void) { [super activate]; }],
                     nil
                     ]];
}

@end
