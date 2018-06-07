//
//  CCMenu+CCMenuExt.h
//  wordwars
//
//  Created by callodiez on 10.07.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#import "CCMenu.h"

typedef enum
{
    maAlignedHorizontally,maAlignedVertically
}CCMenuAlign;


@interface CCMenu (Utils)
-(CGSize)getBoundingBoxWithAlignHelp:(CCMenuAlign)align;
@end
