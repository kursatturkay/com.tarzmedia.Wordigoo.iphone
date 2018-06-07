//
//  CCNode+CCNodeUtilities.m
//  YasayanMasallar
//
//  Created by callodiez on 19.05.2013.
//
//

#import "CCNode+Utilities.h"

@implementation CCNode (CCNodeUtilities)

- (CCNode*) getChildByTagRecursive:(int) tag
{
    CCNode* result = [self getChildByTag:tag];
    
    if( result == nil )
    {
        for(CCNode* child in [self children])
        {
            result = [child getChildByTagRecursive:tag];
            if( result != nil )
            {
                break;
            }
        }
    }
    
    return result;
}

@end
