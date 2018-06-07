//
//  CCNode+CCNodeUtilities.h
//  YasayanMasallar
//
//  Created by callodiez on 19.05.2013.
//
//

#import "CCNode.h"

@interface CCNode (CCNodeUtilities)
- (CCNode*) getChildByTagRecursive:(int) tag;
@end
