//
//  WordDescriptionLayer.h
//  wordigoo-iphone
//
//  Created by callodiez on 09.08.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface WordDescriptionLayer : CCLayerColor
{
  
}
+(CCScene*)scene_;

+(void)setSelectedWord:(NSString *)selword;
+(void)setBackScene:(NSString*)backscene;

-(void)setColorForWordsInDescriptionLabel:keyWord Color:(ccColor3B)color;
-(void)setDescriptionLabel:(NSString*)description;

@end
