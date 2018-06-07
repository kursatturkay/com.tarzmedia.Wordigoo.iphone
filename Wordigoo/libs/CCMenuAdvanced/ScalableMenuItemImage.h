//
//  ScalableMenuItemImage.h
//  Wordigoo
//
//  Created by callodiez on 15.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "CCMenuItem.h"

@interface ScalableMenuItemImage : CCMenuItemImage

+(id) itemWithNormalImage: (NSString*)value selectedImage:(NSString*) value2 disabledImage: (NSString*) value3 target:(id) t selector:(SEL) s;

+(id) itemWithNormalImage: (NSString*)value selectedImage:(NSString*) value2 disabledImage:(NSString*) value3 block:(void(^)(id sender))block;

@end