//
//  CCMenu+CCMenuExt.m
//  wordwars
//
//  Created by Kursat Turkay on 10.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "CCMenu+Utils.h"

@implementation CCMenu (Utils)


-(CGSize)getBoundingBoxWithAlignHelp:(CCMenuAlign)align
{
    CGSize ret_;
    int x=0,y=0;
    
    if (align==maAlignedHorizontally)
    {
        
        for (CCMenuItem *ee in [self children]) {
            x+=ee.boundingBox.size.width;
            y=ee.boundingBox.size.height;
        }
    }
    else if (align==maAlignedVertically)
    {
        
        for (CCMenuItem *ee in [self children]) {
            x=ee.boundingBox.size.width;
            y+=ee.boundingBox.size.height;
        }
    }

    ret_=CGSizeMake(x,y);
    return ret_;
}
@end
