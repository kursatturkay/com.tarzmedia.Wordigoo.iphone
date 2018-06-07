//
//  GlobalEnums.h
//  wordigoo-iphone
//
//  Created by callodiez on 03.09.2013.
//  Copyright (c) 2013 tarzmedia. All rights reserved.
//

#ifndef wordigoo_iphone_GlobalEnums_h
#define wordigoo_iphone_GlobalEnums_h

typedef enum WGScoreCoreAsyncResultType:NSUInteger {
    arForNone= 0,
    arForRegisterUser= 1,
    arForIsRegisteredBefore=2,
    arForGetRank=3,
    arForPostRank=4,
}WGScoreCoreAsyncResultType;
#endif
